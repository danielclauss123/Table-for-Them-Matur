import Foundation
import Firebase
import FirebaseFirestoreSwift
import SystemConfiguration

@MainActor
class MyAccountViewModel: ObservableObject {
    @Published var restaurant: Restaurant?
    @Published var yelpRestaurant: YelpRestaurantDetail?
    
    @Published var errorMessage = ""
    
    var userEmail: String {
        Auth.auth().currentUser?.email ?? ""
    }
    
    func loadRestaurant() async {
        errorMessage = ""
        
        if !SCNetworkConnection.isConnectedToNetwork() {
            errorMessage = "Keine Internetverbindung. Verbinde dich und ziehe von oben herunter zum aktualisieren."
        }
        
        do {
            let restaurant = try await Firestore.userRestaurant()
            
            self.restaurant = restaurant
            
            self.yelpRestaurant = try await URLSession.shared.restaurantDetails(forYelpId: restaurant.yelpId)
        } catch {
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain, nsError.code == NSURLErrorCancelled {
                print("Restaurant loading cancelled.")
                return
            }
            
            errorMessage = "Laden der Daten ist fehlgeschlagen. Ziehe von oben herunter, um es erneut zu versuchen."
            print("Failed to load either restaurant from firestore or from yelp: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = "Abmelden schlug fehl: \(error.localizedDescription)"
            
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
}
