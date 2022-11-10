import SwiftUI

struct RoomReservedTableView: View {
    let room: Room
    let reservedTableId: String
    
    @State private var scale = 1.0
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(room.tables) { table in
                    let color = { () -> Color in
                        if table.id == reservedTableId {
                            return .accentColor
                        } else {
                            return .secondary
                        }
                    }()
                    
                    TableView(table: table, seatFill: color, tableFill: color)
                        .offset(table.offset)
                        .scaleEffect(scale)
                }
            }
            .frame(width: room.size.width * scale, height: room.size.height * scale)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .task {
                scale = room.perfectScale(inGeometry: geometry)
            }
        }
    }
}

struct RoomReservedTableView_Previews: PreviewProvider {
    static var previews: some View {
        RoomReservedTableView(room: Room.examples[0], reservedTableId: Room.examples[0].tables.first?.id ?? "ID")
    }
}
