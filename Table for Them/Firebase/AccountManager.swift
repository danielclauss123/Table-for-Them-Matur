import Foundation
import Firebase

// MARK: - Class
@MainActor
/// The manager for the authorization and existence of a restaurant document of the current user.
class AccountManager: ObservableObject {
    @Published var authorizationStatus = AuthorizationStatus.undefined
    @Published var restaurantDocumentStatus = RestaurantDocumentStatus.undefined
    @Published var errorMessage: String?
    
    private let firebaseService = FirebaseService()
    
    /// The shared instance of this class.
    static let shared = AccountManager()
    
    private init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.authorizationStatus = .signedIn
                
                self.checkRestaurantDocumentExistence()
            } else {
                self.authorizationStatus = .signedOut
            }
        }
    }
    
    /// Checks whether there is a  restaurant document for the current user.
    func checkRestaurantDocumentExistence() {
        Task {
            self.errorMessage = nil
            
            do {
                guard let user = Auth.auth().currentUser else {
                    throw NSError(domain: AuthErrorDomain, code: AuthErrorCode.nullUser.rawValue)
                }
                
                if try await self.firebaseService.restaurantDocumentExists(forUser: user) {
                    self.restaurantDocumentStatus = .exists
                } else {
                    self.restaurantDocumentStatus = .notExists
                }
            } catch {
                print("Checking whether the restaurant document exists failed: \(error.localizedDescription)")
                
                self.restaurantDocumentStatus = .checkingFailed
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    enum AuthorizationStatus {
        case signedIn, signedOut, undefined
    }
    
    enum RestaurantDocumentStatus {
        case undefined, exists, notExists, checkingFailed
    }
}

// MARK: - UI Properties
extension AccountManager {
    enum ManagerView {
        case loading, signIn, createRestaurant, main, error
    }
    
    var viewToShow: ManagerView {
        switch authorizationStatus {
            case .undefined:
                return .loading
            case .signedOut:
                return .signIn
            case .signedIn:
                switch restaurantDocumentStatus {
                    case .undefined:
                        return .loading
                    case .exists:
                        return .main
                    case .notExists:
                        return .createRestaurant
                    case .checkingFailed:
                        return .error
                }
        }
    }
}

// MARK: - Firebase Service
extension AccountManager {
    private actor FirebaseService {
        func restaurantDocumentExists(forUser user: User) async throws -> Bool {
            let reference = Firestore.collection(.restaurants).document(user.uid)
            let document = try await reference.getDocument()
            
            return document.exists
        }
    }
}
