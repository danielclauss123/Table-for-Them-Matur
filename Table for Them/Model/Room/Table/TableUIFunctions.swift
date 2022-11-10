import SwiftUI

// MARK: - Static Properties
extension Table {
    /// The height of the tabletop.
    static let tabletopHeight = 60.0
    /// The size of a chair.
    static let seatSize = CGSize(width: 30, height: 12)
    /// The spacing between the tabletop and a chair.
    static let tableToSeatSpacing = 2.5
}

// MARK: - Instance Properties
extension Table {
    /// The ratio of width / height of the tabletop.
    var tabletopWidthToHeightRatio: Int {
        if headSeatsEnabled {
            return seats.count > 4 ? max(Int(Double(seats.count - 2 + 1) / 2), 1) : 1
        } else {
            return max(Int(Double(seats.count + 1) / 2), 1)
        }
    }
    
    /// The width of the tabletop.
    var tabletopWidth: Double {
        Double(tabletopWidthToHeightRatio) * Table.tabletopHeight
    }
    
    /// The width of the whole table view including the tabletop, the chairs and the space between.
    var width: Double {
        let numberOfHeadSeats = leftHeadSeat != nil ? (rightHeadSeat != nil ? 2 : 1) : 0
        
        return tabletopWidth + (Self.tableToSeatSpacing + Self.seatSize.height) * Double(numberOfHeadSeats)
    }
    
    /// The height of the whole table view including the tabletop, the chairs and the space between.
    var height: Double {
        seats.count > 1 ? Self.tabletopHeight + Self.tableToSeatSpacing * 2 + Self.seatSize.height * 2 : Self.tabletopHeight + Self.tableToSeatSpacing + Self.seatSize.height
    }
}
