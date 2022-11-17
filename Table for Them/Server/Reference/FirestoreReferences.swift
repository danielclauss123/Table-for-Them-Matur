/*
 Abstract:
    Reference zu Firestore.
*/

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension Firestore {
    /// A reference to one of the main collections in Firestore.
    static func collection(_ collection: FirestoreCollection) -> CollectionReference {
        firestore().collection(collection.rawValue)
    }
    
    static func restaurant() throws -> DocumentReference {
        let userId = try Auth.currentUser().uid
        
        return collection(.restaurants).document(userId)
    }
}

/// The main collections in Firestore.
enum FirestoreCollection: String {
    case restaurants, reservations
}
