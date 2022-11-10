import Foundation

extension Restaurant {
    static let examples = [
        Restaurant(id: UUID().uuidString, yelpId: "h2eeVnhUL8zEbTnUrjJomw", name: "Restaurant Hirschli", geoPoint: GeoHashCoordinate(latitude: 47.4742813, longitude: 8.3077803), isActive: true),
        Restaurant(id: UUID().uuidString, yelpId: "h2ehL8zEbTnUrjJomw", name: "Kafisatz", geoPoint: GeoHashCoordinate(latitude: 45, longitude: 8), isActive: true),
        Restaurant(id: UUID().uuidString, yelpId: "h2VnhUL8zEbTnUrjJomw", name: "Kafisatz2", geoPoint: GeoHashCoordinate(latitude: 45.1, longitude: 8), isActive: false)
    ]
}
