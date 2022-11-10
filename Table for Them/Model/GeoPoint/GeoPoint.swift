/*
 Abstract:
    Protocol für codable Coordinate.
    Type für codable Coordinate.
    Type für codable Coordinate mit Geo Hash.
 */

import Foundation
import CoreLocation

// MARK: - Geo Point Protocol
/// A protocol vor codable coordinate types.
protocol GeoPoint: Codable, Hashable {
    var latitude: Double { get set }
    var longitude: Double { get set }
    
    init(latitude: Double, longitude: Double)
}

extension GeoPoint {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Coordinate
/// A codable coordinate with latitude and longitude.
struct Coordinate: GeoPoint {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// Coordinate of 0,0.
    static let zero = Coordinate(latitude: 0, longitude: 0)
}

// MARK: - Geo Hash Coordinate
/// A codable coordinate that also includes the geo hash coordinates.
struct GeoHashCoordinate: GeoPoint {
    var latitude: Double {
        didSet {
            setGeoHash()
        }
    }
    var longitude: Double {
        didSet {
            setGeoHash()
        }
    }
    
    private(set) var geoHashExact: String
    private(set) var geoHash4: String
    private(set) var geoHash3: String
    private(set) var geoHash2: String
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        
        self.geoHashExact = ""
        self.geoHash4 = ""
        self.geoHash3 = ""
        self.geoHash2 = ""
        
        self.setGeoHash()
    }
    
    private mutating func setGeoHash() {
        self.geoHashExact = Geohash.encode(latitude: latitude, longitude: longitude, 9)
        self.geoHash4 = Geohash.encode(latitude: latitude, longitude: longitude, 4)
        self.geoHash3 = Geohash.encode(latitude: latitude, longitude: longitude, 3)
        self.geoHash2 = Geohash.encode(latitude: latitude, longitude: longitude, 2)
    }
    
    /// Coordinate of 0,0.
    static let zero = GeoHashCoordinate(latitude: 0, longitude: 0)
}
