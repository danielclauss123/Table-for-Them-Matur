import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class ReservationRepo: ObservableObject {
    @Published private(set) var reservations = [Reservation]()
    
    @Published private(set) var loadingStatus = Firestore.LoadingStatus.ready
    
    private var currentListener: ListenerRegistration?
    private var currentListenerId: UUID?
    
    var currentReservations: [Reservation] {
        reservations.filter { $0.date > Date.now.addingTimeInterval(-60 * 60) }
    }
    
    var pastReservations: [Reservation] {
        var reservations = reservations
        
        reservations.removeAll(where: { currentReservations.contains($0) })
        
        return reservations
    }
    
    // MARK: Init
    init() {
        addListener()
    }
    
    // MARK: Deinit
    deinit {
        currentListener?.remove()
    }
    
    // MARK: Add Listener
    private func addListener() {
        loadingStatus = .loading
        reservations = []
        currentListener?.remove()
        
        guard let userId = Auth.currentUser()?.uid else {
            print("The user is not logged in.")
            loadingStatus = .error("Du bist nicht eingeloggt.")
            return
        }
        
        let listenerId = UUID()
        currentListenerId = listenerId
        
        let reference = Firestore.collection(.reservations)
            .whereField("restaurantId", isEqualTo: userId)
            .whereField("date", isGreaterThan: Timestamp(date: Date.now.addingTimeInterval(-60 * 60 * 24 * 7)))
            .order(by: "date")
        
        currentListener = reference.addSnapshotListener { snapshot, error in
            guard self.currentListenerId == listenerId else {
                print("There is a newer listener than the current one. This one gets ignored.")
                return
            }
            
            guard let snapshot = snapshot else {
                self.loadingStatus = .error("Fehler beim laden.")
                
                print("Failed to load reservations. Error: \(error?.localizedDescription ?? "Unknown Error.")")
                return
            }
            
            self.reservations = snapshot.documents.compactMap { document in
                do {
                    return try document.data(as: Reservation.self)
                } catch {
                    print("Failed to decode reservation document \(document.documentID). Error: \(error.localizedDescription)")
                    return nil
                }
            }
            
            self.loadingStatus = .ready
        }
    }
}
