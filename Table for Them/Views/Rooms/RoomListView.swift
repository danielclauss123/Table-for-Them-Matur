import SwiftUI

struct RoomListView: View {
    @ObservedObject var roomRepository: RoomRepository
    
    @State private var showingNewRoomSheet = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                switch roomRepository.loadingStatus {
                    case .loading:
                        EmptyView()
                    case .firestoreError(let error):
                        Section("Fehler") {
                            Text(error)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                        }
                    case .ready:
                        roomList
                }
            }
            .overlay {
                if roomRepository.loadingStatus == .loading {
                    ProgressView()
                }
            }
            .navigationTitle("Tischpläne")
            .toolbar {
                Button {
                    showingNewRoomSheet = true
                } label: {
                    Label("Neuer Raum", systemImage: "plus")
                }
                .disabled(roomRepository.loadingStatus != .ready)
            }
            .searchable(text: $roomRepository.searchText)
            .sheet(isPresented: $showingNewRoomSheet) {
                NewRoomView(viewModel: NewRoomViewModel(newRoomNumber: roomRepository.rooms.count + 1))
            }
        }
    }
    
    // MARK: - Room List
    var roomList: some View {
        ForEach(roomRepository.searchedRooms) { room in
            RoomRowView(room: room)
        }
    }
}


// MARK: - Previews
struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView(roomRepository: .example)
    }
}
