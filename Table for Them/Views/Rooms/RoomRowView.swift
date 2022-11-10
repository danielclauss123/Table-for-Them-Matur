import SwiftUI
import FirebaseFirestoreSwift

struct RoomRowView: View {
    let room: Room
    
    @State private var showingEditingSheet = false
    @State private var showingDeleteConfirmation = false
    
    @State private var showingDeletionErrorAlert = false
    
    // MARK: - Body
    var body: some View {
        NavigationLink(destination: RoomEditingView(room: room)) {
            VStack(alignment: .leading) {
                Text(room.name)
                    .font(.title2.bold())
                Text("\(room.tables.count) \(room.tables.count == 1 ? "Tisch" : "Tische")")
                    .foregroundColor(.secondary)
            }
        }
        .contextMenu {
            Button {
                showingEditingSheet = true
            } label: {
                Label("Bearbeiten", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                showingDeleteConfirmation = true
            } label: {
                Label("Löschen", systemImage: "trash")
            }
        }
        .swipeActions {
            Button(role: .destructive) {
                showingDeleteConfirmation = true
            } label: {
                Label("Löschen", systemImage: "trash")
            }
            
            Button {
                showingEditingSheet = true
            } label: {
                Label("Bearbeiten", systemImage: "pencil")
            }
        }
        .sheet(isPresented: $showingEditingSheet) {
            NewRoomView(viewModel: NewRoomViewModel(roomToEdit: room))
        }
        .confirmationDialog("Raum löschen", isPresented: $showingDeleteConfirmation) {
            Button("Löschen", role: .destructive) {
                Task {
                    await deleteRoom()
                }
            }
        } message: {
            Text("Möchtest du \"\(room.name)\" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.")
        }
        .alert("Löschen von \"\(room.name)\" ist fehlgeschlagen.", isPresented: $showingDeletionErrorAlert) {
            Button("Ok") { }
        }
    }
    
    // MARK: - Delete Room
    func deleteRoom() async {
        do {
            try await room.deleteFromFirestore()
        } catch {
            print("Failed to delete room: \(error.localizedDescription)")
            
            showingDeletionErrorAlert = true
        }
    }
}


// MARK: - Previews
struct RoomRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                RoomRowView(room: Room.examples[0])
            }
        }
    }
}
