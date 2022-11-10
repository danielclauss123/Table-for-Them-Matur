import SwiftUI

struct ReservationDetailView: View {
    let reservation: Reservation
    let room: Room?
    
    var body: some View {
        ScrollView {
            VStack {
                InsetScrollViewSection(title: "Daten") {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                Text(reservation.date, style: .time)
                                +
                                Text(", ")
                                
                                Text(reservation.date, style: .date)
                            }
                            .bold()
                            
                            Text("**\(reservation.numberOfPeople) \(reservation.numberOfPeople == 1 ? "Person" : "Personen")**")
                            +
                            Text(" unter \(reservation.customerName)")
                        }
                        Spacer()
                    }
                }
                
                InsetScrollViewSection(title: "Tisch") {
                    if let room = room {
                        VStack(alignment: .leading) {
                            Text("\(room.name)")
                                .bold()
                            
                            RoomReservedTableView(room: room, reservedTableId: reservation.tableId)
                                .frame(height: 270)
                        }
                    } else {
                        Text("Raum existiert nicht mehr.")
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("Reservation \(reservation.customerName)")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .secondarySystemBackground).ignoresSafeArea())
    }
}

struct ReservationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReservationDetailView(reservation: .example, room: .examples[0])
        }
    }
}
