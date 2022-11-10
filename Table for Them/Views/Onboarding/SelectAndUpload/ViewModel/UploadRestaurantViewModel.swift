// There needs to be a transaction to be really safe.

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SystemConfiguration

@MainActor
class UploadRestaurantViewModel: ObservableObject {
    let yelpRestaurant: YelpRestaurantOverview
    let restaurant: Restaurant
    
    @Published var uploadingState = UploadingState.inProcess {
        didSet {
            if uploadingState == .successfullyCompleted {
                uploadWasSuccessful = true
            }
        }
    }
    @Published var uploadWasSuccessful = false
    
    var userIdIsValid = true
    
    private let firebaseService = FirebaseService()
    
    init(yelpRestaurant: YelpRestaurantOverview) {
        self.yelpRestaurant = yelpRestaurant
        
        if Auth.currentUser() == nil {
            uploadingState = .failed("Du bist nicht angemeldet. Starte die App neu und melde dich erneut an.")
            userIdIsValid = false
            print("The current user id is nil.")
        }
        
        let geoHashCoordinate = GeoHashCoordinate(latitude: yelpRestaurant.coordinate.latitude, longitude: yelpRestaurant.coordinate.longitude)
        
        self.restaurant = Restaurant(
            id: Auth.currentUser()?.uid,
            yelpId: yelpRestaurant.id,
            name: yelpRestaurant.name,
            geoPoint: geoHashCoordinate,
            isActive: true
        )
    }
    
    func uploadRestaurant() async {
        guard userIdIsValid else { return }
        
        uploadingState = .inProcess
        
        guard SCNetworkConnection.isConnectedToNetwork() else {
            uploadingState = .failed("Keine Internet Verbindung.")
            return
        }
        
        do {
            if try await firebaseService.restaurantAlreadyExists(restaurant) {
                uploadingState = .restaurantIsAlreadyTaken
                return
            }
            
            try await firebaseService.uploadRestaurant(restaurant)
            
            uploadingState = .successfullyCompleted
        } catch {
            uploadingState = .failed("Es gab ein Problem: \(error.localizedDescription) Versuche erneut.")
            print("There has been an error while checking and uploading the restaurant to firestore: \(error.localizedDescription)")
        }
    }
    
    enum UploadingState: Equatable {
        case inProcess, successfullyCompleted, failed(String), restaurantIsAlreadyTaken
    }
}

private actor FirebaseService {
    // Would need transaction to be save.
    func restaurantAlreadyExists(_ restaurant: Restaurant) async throws -> Bool {
        let documents = try await Firestore
            .collection(.restaurants)
            .whereField("yelpId", isEqualTo: restaurant.yelpId)
            .getDocuments()
        
        return !documents.isEmpty
    }
    
    func uploadRestaurant(_ restaurant: Restaurant) throws {
        if let id = restaurant.id {
            try Firestore.collection(.restaurants).document(id).setData(from: restaurant)
        } else {
            throw RestaurantUploadingError.restaurantIdIsNil
        }
    }
    
    enum RestaurantUploadingError: Error, LocalizedError {
        case restaurantIdIsNil
        
        var errorDescription: String? {
            switch self {
                case .restaurantIdIsNil:
                    return "The id of the restaurant is nil."
            }
        }
    }
}
