import Foundation

class NewRoomViewModel: ObservableObject {
    @Published var room: Room
    
    @Published var errorMessage: String?
    @Published var showingErrorAlert = false
    
    let creatingNewRoom: Bool
    
    /// The init for a new room.
    ///
    ///  The number of the room, meaning for example this is the third room -> 3, should be given to give the room a default name.
    init(newRoomNumber: Int) {
        creatingNewRoom = true
        
        self.room = Room.new(newRoomNumber)
    }
    
    /// The init to edit an existing room.
    init(roomToEdit: Room) {
        creatingNewRoom = false
        
        self.room = roomToEdit
    }
    
    func saveToFirestore() {
        guard !room.name.isEmpty else {
            errorMessage = "Der Raum muss einen Namen haben. Fülle das Namen Feld aus und versuche es erneut."
            showingErrorAlert = true
            return
        }
        
        do {
            try room.setToFirestore()
        } catch {
            print("Failed to set room to firebase: \(error.localizedDescription)")
            
            errorMessage = "Bearbeiten des Raums fehlgeschlagen. Versuche es erneut."
            showingErrorAlert = true
        }
    }
}
