import Foundation
import CoreLocation
import Firebase
import FirebaseFirestoreSwift

// MARK: - Struct
struct Restaurant: Identifiable, Codable {
    @DocumentID var id: String?
    
    var yelpId: String
    var name: String
    private(set) var geoPoint: GeoHashCoordinate
    var isActive: Bool
}

// MARK: - Computed Properties
extension Restaurant {
    /// The id unwrapped with a uuid default.
    var uuidUnwrappedId: String {
        id ?? UUID().uuidString
    }
    
    /// The coordinate of the restaurant.
    ///
    /// It accesses the private geoPoint var that can be uploaded to firebase.
    var coordinate: CLLocationCoordinate2D {
        get {
            geoPoint.clLocationCoordinate2D
        } set {
            geoPoint.latitude = newValue.latitude
            geoPoint.longitude = newValue.longitude
        }
    }
}
