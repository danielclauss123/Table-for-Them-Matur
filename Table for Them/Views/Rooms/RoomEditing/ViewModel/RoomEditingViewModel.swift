import Foundation
import FirebaseFirestoreSwift

class RoomEditingViewModel: ObservableObject {
    @Published var room: Room
    
    @Published var errorMessage: String?
    @Published var showingErrorAlert = false
    
    private var lastSavedRoom: Room
    
    init(room: Room) {
        self.room = room
        self.lastSavedRoom = room
    }
    
    func resetToLastSaved() {
        room = lastSavedRoom
    }
    
    func saveToFirebase() {
        do {
            try room.setToFirestore()
            lastSavedRoom = room
        } catch {
            print("Failed to set room to firebase: \(error.localizedDescription)")
            
            errorMessage = "Speichern der Änderungen fehlgeschlagen."
            showingErrorAlert = true
        }
    }
    
    static let example = RoomEditingViewModel(room: .examples[0])
}
