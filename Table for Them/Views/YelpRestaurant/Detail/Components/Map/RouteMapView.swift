/*
 Abstract:
    A SwiftUI map view that displays a route from a given location or the user location to a given destination location.
 
 Source:
    This map was made by combining multiple concepts and adding to them myself.
    MapView: HackingWithSwift, Site might not be available anymore.
    Route: https://medium.com/swlh/swiftui-tutorial-finding-a-route-and-directions-52b973530f8d
 */

import SwiftUI
import MapKit

// MARK: - Route Map View
/// A view that displays a route from the a given location / the user location to a destination location.
struct RouteMapView: UIViewRepresentable {
    var start: CLLocationCoordinate2D? = nil
    var startName: String? = nil
    let destination: CLLocationCoordinate2D
    let destinationName: String
    
    var mapType = MKMapType.standard
    var onRouteCalculationFinished: (MKRoute) -> Void = { _ in }
    
    private let locationFetcher = LocationFetcher()
    
    @State private var route: MKRoute?
    
    // MARK: - Make UIView
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        mapView.mapType = mapType
        mapView.showsCompass = false
        mapView.showsUserLocation = true
        
        mapView.delegate = context.coordinator
        
        let destinationAnnotation = MKPointAnnotation(coordinate: destination, title: destinationName)
        mapView.addAnnotation(destinationAnnotation)
        
        if let start = start {
            let startAnnotation = MKPointAnnotation(coordinate: start, title: startName ?? "")
            mapView.addAnnotation(startAnnotation)
            
            Task {
                await calculateRoute(fromStart: start, toDestination: destination)
            }
        } else {
            locationFetcher.onFirstUpdate = { userLocation in
                guard let userLocation = userLocation else { return }
                
                Task {
                    await calculateRoute(fromStart: userLocation, toDestination: destination)
                }
            }
        }
        
        locationFetcher.start()
        
        return mapView
    }
    
    // MARK: - Update UIView
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.mapType = mapType
        
        if let route = route {
            uiView.addOverlay(route.polyline)
            uiView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true
            )
        }
    }
    
    // MARK: - Calculate Route
    func calculateRoute(fromStart start: CLLocationCoordinate2D, toDestination destination: CLLocationCoordinate2D) async {
        do {
            let route = try await MKDirections.route(from: start, to: destination)
            onRouteCalculationFinished(route)
            self.route = route
        } catch {
            print("Error while calculating route: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Make Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// MARK: - Coordinator
extension RouteMapView {
    class Coordinator: NSObject, MKMapViewDelegate {
        let parent: RouteMapView
        
        init(_ parent: RouteMapView) {
            self.parent = parent
        }
        
        // MARK: - View For Annotation
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !annotation.isEqual(mapView.userLocation) else {
                return MKUserLocationView(annotation: annotation, reuseIdentifier: "UserPlacemark")
            }
            
            let identifier = "Placemark"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        // MARK: - Polyline Renderer
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            
            return renderer
        }
    }
}


// MARK: - Previews
struct RouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        RouteMapView(
            start: CLLocationCoordinate2D(latitude: 47.49220, longitude: 8.73342),
            startName: "Start",
            destination: CLLocationCoordinate2D(latitude: 47.59225, longitude: 8.73343),
            destinationName: "Destination"
        )
        .ignoresSafeArea()
    }
}
