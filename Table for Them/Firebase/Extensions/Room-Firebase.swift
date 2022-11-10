import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Room {
    var firestoreReference: DocumentReference {
        get throws {
            try Firestore.restaurant().collection("rooms").document(self.id.unwrapWithUUID())
        }
    }
    
    func setToFirestore() throws {
        try firestoreReference.setData(from: self)
    }
    
    func deleteFromFirestore() async throws {
        try await firestoreReference.delete()
    }
}
