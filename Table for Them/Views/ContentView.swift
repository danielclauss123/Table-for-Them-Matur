import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @StateObject var roomRepository: RoomRepository
    
    var body: some View {
        TabView {
            ReservationsListView(roomRepo: roomRepository)
                .tabItem {
                    Label("Reservationen", systemImage: "tray")
                }
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    RoomListView(roomRepository: roomRepository)
                    
                    VStack(spacing: 0) {
                        Divider()
                        
                        Rectangle().fill(.regularMaterial)
                    }
                    .frame(height: geometry.safeAreaInsets.bottom)
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .tabItem {
                Label("Tischpläne", systemImage: "rectangle.grid.2x2")
            }
            
            MyAccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
        }
        /*.task {
            let example = Room(id: "roomExample", name: "Example Room", tables: [Table(name: "Example Table", seats: [Seat()], headSeatsEnabled: true)], size: .zero)
            
            try! Firestore.restaurant().collection("rooms").document(example.id.unwrapWithUUID()).setData(from: example)
        }*/
    }
    
    init() {
        self._roomRepository = StateObject(wrappedValue: RoomRepository())
    }
}


// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
