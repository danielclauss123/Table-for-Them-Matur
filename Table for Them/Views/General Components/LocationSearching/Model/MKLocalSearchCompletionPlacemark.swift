/*
 Abstract:
    Eine async Funktion die ein MKPlacemark für eine SearchCompletion zurückgibt.
 */

import Foundation
import MapKit

// MARK: - Placemark
extension MKLocalSearchCompletion {
    func placemark() async throws -> MKPlacemark {
        let localSearchRequest = MKLocalSearch.Request(completion: self)
        let localSearch = MKLocalSearch(request: localSearchRequest)
        
        let response = try await localSearch.start()
        
        guard let placemark = response.mapItems.first?.placemark else {
            throw LocalSearchError.mapItemsIsEmpty
        }
        
        return placemark
    }
    
    /// An error that might happen while annotation() gets called.
    enum LocalSearchError: Error, LocalizedError {
        case mapItemsIsEmpty
        
        var errorDescription: String? {
            switch self {
            case .mapItemsIsEmpty:
                return "The mapItems property of the response does not contain any items."
            }
        }
    }
}
