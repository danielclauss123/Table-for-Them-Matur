import SwiftUI

struct ReservationRowView: View {
    let reservation: Reservation
    let room: Room?
    
    // MARK: Body
    var body: some View {
        NavigationLink {
            ReservationDetailView(reservation: reservation, room: room)
        } label: {
            HStack {
                Group {
                    if let room = room {
                        RoomReservedTableView(room: room, reservedTableId: reservation.tableId)
                    } else {
                        Color.secondary
                    }
                }
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text(reservation.customerName)
                        .font(.title3.bold())
                    
                    HStack(spacing: 0) {
                        Text(reservation.date, style: .time)
                        +
                        Text(", ")
                        
                        Text(reservation.date, style: .date)
                            .lineLimit(1)
                    }
                    
                    Text("\(reservation.numberOfPeople) \(reservation.numberOfPeople == 1 ? "Person" : "Personen")")
                    
                    if let room = room {
                        Text(room.name)
                    }
                }
            }
        }

    }
}

struct ReservationRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                ReservationRowView(reservation: .examples[0], room: .examples[0])
            }
        }
    }
}
