/*
 Abstract:
    Zero, mit Koordinaten 0,0.
    Computed Property zu MKPlacemark und MKMapItem.
    Open in maps Funktion.
    Distanz zwischen zwei CLLocationCoordinate2D.
    Equatable Conformance.
 */

import Foundation
import CoreLocation
import MapKit

// MARK: - Zero
extension CLLocationCoordinate2D {
    /// The latitude and longitude are both 0.
    static let zero = CLLocationCoordinate2D(latitude: 0, longitude: 0)
}

// MARK: - Placemark and MapItem
extension CLLocationCoordinate2D {
    var placemark: MKPlacemark {
        MKPlacemark(coordinate: self)
    }
    
    var mapItem: MKMapItem {
        MKMapItem(placemark: placemark)
    }
}

// MARK: - Open in Maps
extension CLLocationCoordinate2D {
    /// Opens the maps app and displays this location.
    func openInMaps(withName name: String?) {
        let mapItem = mapItem
        
        mapItem.name = name
        
        mapItem.openInMaps()
    }
    
    /// Opens the maps app with a route from the user location to this location.
    func openInMapsAsRoute(withName name: String?) {
        let mapItem = mapItem
        
        mapItem.name = name
        
        mapItem.openInMaps(
            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        )
    }
}

// MARK: - Distance
extension CLLocationCoordinate2D {
    /// Calculates the distance in meters between two coordinates.
    /// - Parameter from: The coordinate to which the distance should be calculated.
    /// - Returns: The distance in meters.
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        return to.distance(from: from)
    }
}

// MARK: - Protocol Conformances
extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
