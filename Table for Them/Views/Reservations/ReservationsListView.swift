import SwiftUI

struct ReservationsListView: View {
    @StateObject var reservationRepo: ReservationRepo
    @ObservedObject var roomRepo: RoomRepository
    
    @State private var currentIsExpanded = true
    
    var body: some View {
        NavigationStack {
            List {
                Section("Anstehende") {
                    ForEach(reservationRepo.currentReservations) { reservation in
                        ReservationRowView(reservation: reservation, room: roomRepo.room(forId: reservation.roomId))
                    }
                }
                
                Section("Vergangene") {
                    ForEach(reservationRepo.pastReservations) { reservation in
                        ReservationRowView(reservation: reservation, room: roomRepo.room(forId: reservation.roomId))
                    }
                }
            }
            .navigationTitle("Reservationen")
        }
    }
    
    init(roomRepo: RoomRepository) {
        self._reservationRepo = StateObject(wrappedValue: ReservationRepo())
        self.roomRepo = roomRepo
    }
}

struct ReservationsListView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationsListView(roomRepo: .example)
    }
}
