import SwiftUI

struct TableView<SeatFill: ShapeStyle, TableFill: ShapeStyle>: View {
    let table: Table
    
    let seatFill: SeatFill
    let tableFill: TableFill
    
    // MARK: - Body
    var body: some View {
        DynamicalStack(table.rotation.isHorizontal ? .horizontal : .vertical, spacing: Table.tableToSeatSpacing) {
            // Left head seat
            if ([Table.Rotation.normal, .up].contains(table.rotation) && table.leftHeadSeat != nil) || ([Table.Rotation.right, .down].contains(table.rotation) && table.rightHeadSeat != nil) {
                Capsule()
                    .fill(seatFill)
                    .seatFrame(table.rotation.isHorizontal ? .vertical : .horizontal)
            }
            
            DynamicalStack(table.rotation.isHorizontal ? .vertical : .horizontal, spacing: Table.tableToSeatSpacing) {
                // Top seats
                DynamicalStack(table.rotation.isHorizontal ? .horizontal : .vertical, spacing: 0) {
                    ForEach([Table.Rotation.normal, .down].contains(table.rotation) ? table.topSeats : table.bottomSeats) { _ in
                        Spacer(minLength: 1)
                        Capsule()
                            .fill(seatFill)
                            .seatFrame(table.rotation.isHorizontal ? .horizontal : .vertical)
                        Spacer(minLength: 1)
                    }
                }
                
                // Tabletop
                RoundedRectangle(cornerRadius: 10)
                    .fill(tableFill)
                    .tableFrame(forTable: table)
                
                // Bottom seats
                DynamicalStack(table.rotation.isHorizontal ? .horizontal : .vertical, spacing: 0) {
                    ForEach([Table.Rotation.normal, .down].contains(table.rotation) ? table.bottomSeats : table.topSeats) { _ in
                        Spacer(minLength: 1)
                        Capsule()
                            .fill(seatFill)
                            .seatFrame(table.rotation.isHorizontal ? .horizontal : .vertical)
                        Spacer(minLength: 1)
                    }
                }
            }
            
            // Right head seat
            if ([Table.Rotation.right, .down].contains(table.rotation) && table.leftHeadSeat != nil) || ([Table.Rotation.normal, .up].contains(table.rotation) && table.rightHeadSeat != nil) {
                Capsule()
                    .fill(seatFill)
                    .seatFrame(table.rotation.isHorizontal ? .vertical : .horizontal)
            }
        }
        .tableViewFrame(forTable: table)
        .shadow(radius: 5)
    }
}

// MARK: - Table Frame
extension View {
    fileprivate func tableFrame(forTable table: Table) -> some View {
        frame(
            width: table.rotation.isHorizontal ? table.tabletopWidth : Table.tabletopHeight,
            height: table.rotation.isHorizontal ? Table.tabletopHeight : table.tabletopWidth
        )
    }
}

// MARK: - Seat Frame
extension View {
    fileprivate func seatFrame(_ axis: Axis.Set) -> some View {
        frame(
            width: axis == .horizontal ? Table.seatSize.width : Table.seatSize.height,
            height: axis == .horizontal ? Table.seatSize.height : Table.seatSize.width
        )
    }
}

// MARK: - Table View Frame
extension View {
    fileprivate func tableViewFrame(forTable table: Table) -> some View {
        frame(
            width: table.rotation.isHorizontal ? table.width : table.height,
            height: table.rotation.isHorizontal ? table.height : table.width
        )
    }
}


// MARK: - Previews
struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(
            table: .example(seatCount: 13, sideSeats: true, rotation: .down),
            seatFill: Color.blue,
            tableFill: Color.indigo
        )
        .previewLayout(.sizeThatFits)
    }
}
