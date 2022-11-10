import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class RoomRepository: ObservableObject {
    @Published private(set) var rooms = [Room]()
    
    @Published var searchText = ""
    
    @Published private(set) var loadingStatus = LoadingStatus.ready
    
    private var currentListener: ListenerRegistration?
    private var currentListenerId: UUID?
    
    var searchedRooms: [Room] {
        rooms.filter { $0.name.lowercased().hasPrefix(searchText.lowercased()) }
    }
    
    // MARK: - Init
    init() {
        addFirestoreListener()
    }
    
    // MARK: - Example Init
    private init(rooms: [Room]) {
        self.rooms = rooms
    }
    
    // MARK: - Add Firestore Listener
    func addFirestoreListener() {
        loadingStatus = .loading
        rooms = []
        currentListener?.remove()
        
        let listenerId = UUID()
        self.currentListenerId = listenerId
        
        guard let reference = try? Firestore.restaurant().collection("rooms") else {
            self.loadingStatus = .firestoreError("The reference to the rooms collection is incorrect.")
            return
        }
        
        currentListener = reference
            .addSnapshotListener { snapshot, error in
                guard self.currentListenerId == listenerId else {
                    print("Different listener that gets executed then the current one.")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Failed to load rooms from firebase: \(error?.localizedDescription ?? "Snapshot is nil.")")
                    self.loadingStatus = .firestoreError(error?.localizedDescription ?? "Unknown Error")
                    return
                }
                
                self.rooms = snapshot.documents.compactMap { document in
                    do {
                        return try document.data(as: Room.self)
                    } catch {
                        print("Failed to decode document: \(error.localizedDescription)")
                        
                        return nil
                    }
                }
                
                self.loadingStatus = .ready
            }
    }
    
    func room(forId id: String) -> Room? {
        rooms.first(where: { $0.id == id })
    }
    
    // MARK: - Loading Status
    enum LoadingStatus: Equatable {
        case ready, loading, firestoreError(String)
    }
}

// MARK: - Example
extension RoomRepository {
    static let example = RoomRepository(rooms: Room.examples)
}
