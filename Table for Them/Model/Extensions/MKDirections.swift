/*
 Abstract:
    Route zwischen zwei CLLocationCoordinate2D
 
 Quelle:
    Idee von https://medium.com/swlh/swiftui-tutorial-finding-a-route-and-directions-52b973530f8d
    Bearbeitet: Stärker bearbeitet.
 */

import MapKit

extension MKDirections {
    /// Returns an MKRoute between two locations.
    static func route(from start: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, withTransportType transportType: MKDirectionsTransportType = .any) async throws -> MKRoute {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: start.placemark)
        request.destination = MKMapItem(placemark: destination.placemark)
        request.transportType = transportType
        
        let directions = MKDirections(request: request)
        
        let response = try await directions.calculate()
        
        guard let route = response.routes.first else {
            throw RouteCalculationError.noRouteFound
        }
        
        return route
    }
    
    enum RouteCalculationError: Error, LocalizedError {
        case noRouteFound
        
        var errorDescription: String? {
            switch self {
                case .noRouteFound:
                    return "The returned routes array is empty."
            }
        }
    }
}
