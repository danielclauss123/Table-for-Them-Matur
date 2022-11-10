/*
 Abstract:
    Restaurant des current user.
 */

import Foundation
import Firebase
import FirebaseFirestoreSwift

extension Firestore {
    /// Returns the restaurant of the current user.
    static func userRestaurant() async throws -> Restaurant {
        try await Firestore.restaurant().getDocument(as: Restaurant.self)
    }
}
