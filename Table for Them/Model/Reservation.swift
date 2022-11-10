import Foundation
import FirebaseFirestoreSwift

// MARK: - Struct
struct Reservation: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    
    var customerId: String
    var customerName: String
    var numberOfPeople: Int
    
    var restaurantId: String
    var yelpId: String
    var roomId: String
    var tableId: String
    
    var date: Date
}

// MARK: - Computed Properties
extension Reservation {
    var endDate: Date {
        date.addingTimeInterval(60 * 60 * 2)
    }
}
