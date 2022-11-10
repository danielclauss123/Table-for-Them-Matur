import Foundation
import CoreLocation

// MARK: - Restaurant Overview
struct YelpRestaurantOverview: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let coordinates: Coordinate
    let isClosed: Bool?
    let imageUrl: String?
    let location: YelpLocation?
    
    var coordinate: CLLocationCoordinate2D {
        coordinates.clLocationCoordinate2D
    }
}

// MARK: - Restaurant Detail
struct YelpRestaurantDetail: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let imageUrl: String?
    let isClosed: Bool?
    let url: String
    let phone: String?
    let displayPhone: String?
    let reviewCount: Int?
    let rating: Double?
    let location: YelpLocation?
    let coordinates: Coordinate
    let photos: [String]?
    let price: String?
    let hours: [OpeningHours]?
    let specialHours: [SpecialHours]?
    
    var coordinate: CLLocationCoordinate2D {
        coordinates.clLocationCoordinate2D
    }
    
    var yelpURL: URL {
        URL(string: url) ?? URL(string: "https://www.yelp.com")!
    }
    
    var openingHours: OpeningHours? {
        hours?.first
    }
    
    var priceInt: Int? {
        price?.count
    }
}

// MARK: - Location
struct YelpLocation: Codable, Equatable {
    let address1: String?
    let city: String?
    let zipCode: String?
    let state: String?
    let displayAddress: [String]?
    
    var shortAddress: String {
        "\(address1 ?? "")\(address1 != nil && city != nil ? ", " : "")\(city ?? "")"
    }
    
    var longAddress: String {
        guard let displayAddress = displayAddress else {
            return ""
        }
        
        return displayAddress.reduce(into: "") { $0 += $1 + "\n" }.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
