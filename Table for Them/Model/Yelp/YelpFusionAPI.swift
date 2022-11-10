import Foundation
import CoreLocation

// MARK: - Fusion URLRequest
extension URLRequest {
    /// A url request with the yelp fusion api key.
    static func fusionRequest(forURL url: URL) -> URLRequest {
        let apiKey = "VVfz4vwJORkkK_e3VIG2O8CzU-s9uz3XF_atoHbXjpbzgC1KBmU3ihrAIwT7U2K2WGS-Q9oBrDLC_s4tjCxAXeGZ4i6Lv6Wv0FLO1UooAqe2N941EAdDZfPPpLY1YnYx"
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
}

// MARK: - Restaurant Details
extension URLSession {
    /// Returns the detail information of a restaurant.
    func restaurantDetails(forYelpId id: String) async throws -> YelpRestaurantDetail {
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/\(id)") else {
            throw URLError(.badURL)
        }
        
        let request = URLRequest.fusionRequest(forURL: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(YelpRestaurantDetail.self, from: data)
    }
}

// MARK: - Restaurant Search
extension URLSession {
    /// Searches near restaurants with a search term.
    func restaurantSearch(
        term: String? = nil,
        latitude: Double,
        longitude: Double,
        radius: Int? = nil,
        locale: String? = nil,
        limit: Int? = nil,
        offset: Int? = nil
    ) async throws -> YelpRestaurantSearchResponse {
        let termAttribute = term == nil ? "" : "term=\(term!.replacingOccurrences(of: " ", with: "+"))&"
        let latitudeAttribute = "&latitude=\(latitude)"
        let longitudeAttribute = "&longitude=\(longitude)"
        let radiusAttribute = radius == nil ? "" : "&radius=\(radius!)"
        let localeAttribute = locale == nil ? "" : "&locale=\(locale!)"
        let limitAttribute = limit == nil ? "" : "&limit=\(limit!)"
        let offsetAttribute = offset == nil ? "" : "&offset=\(offset!)"
        
        guard let url = URL(
            string: "https://api.yelp.com/v3/businesses/search?\(termAttribute)\(latitudeAttribute)\(longitudeAttribute)\(radiusAttribute)\(localeAttribute)\(limitAttribute)\(offsetAttribute)"
        ) else {
            throw URLError(.badURL)
        }
        
        let request = URLRequest.fusionRequest(forURL: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(YelpRestaurantSearchResponse.self, from: data)
    }
}

struct YelpRestaurantSearchResponse: Codable {
    let total: Int
    let businesses: [YelpRestaurantOverview]
}
