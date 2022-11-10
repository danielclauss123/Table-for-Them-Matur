import Foundation
import Combine
import CoreLocation

@MainActor
class SearchYourRestaurantViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var restaurants = [YelpRestaurantOverview]()
    
    let locationSearcher = LocationSearcher()
    
    private let searchService = SearchService()
    private var searchTextCancellabel: AnyCancellable?
    
    init() {
        searchTextCancellabel = $searchText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { text in
                Task {
                    guard let coordinate = self.locationSearcher.coordinate else {
                        return
                    }
                    
                    do {
                        self.restaurants = try await self.searchService.search(withText: text, atLocation: coordinate).businesses
                    } catch {
                        print("Error while loading restaurant overviews: \(error.localizedDescription)")
                    }
                }
            }
    }
}

// MARK: - Search Service
private actor SearchService {
    var currentTask: Task<YelpRestaurantSearchResponse, Error>?
    
    func search(withText text: String, atLocation location: CLLocationCoordinate2D) async throws -> YelpRestaurantSearchResponse {
        // Cancels any current task to prevent an older task finishing after a newer task.
        currentTask?.cancel()
        
        currentTask = Task {
            try await URLSession.shared.restaurantSearch(term: text, latitude: location.latitude, longitude: location.longitude, limit: 10)
        }
        
        if let result = try await currentTask?.value {
            return result
        } else {
            throw CancellationError()
        }
    }
}
