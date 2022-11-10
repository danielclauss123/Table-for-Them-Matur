/*
 Abstract:
    Reference zum Restaurant.
    Set Restaurant.
    Löscht Restaurant.
 */

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Restaurant {
    var firestoreReference: DocumentReference {
        Firestore.collection(.restaurants).document(uuidUnwrappedId)
    }
    
    func setToFirestore() throws {
        try firestoreReference.setData(from: self)
    }
    
    func deleteFromFirestore() async throws {
        try await firestoreReference.delete()
    }
}
