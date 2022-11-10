import Foundation
import SwiftUI

// MARK: - Table
/// The type for a table that is inside a room and that can be reserved by a customer.
struct Table: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    
    var seats: [Seat]
    var headSeatsEnabled: Bool
    
    var offset: CGSize
    var rotation: Rotation
    
    init(id: String = UUID().uuidString, name: String, seats: [Seat], headSeatsEnabled: Bool, offset: CGSize = .zero, rotation: Rotation = .normal) {
        self.id = id
        self.name = name
        self.seats = seats
        self.headSeatsEnabled = headSeatsEnabled
        self.offset = offset
        self.rotation = rotation
    }
    
    init(id: String = UUID().uuidString, name: String, numberOfSeats: Int, headSeatsEnabled: Bool, offset: CGSize = .zero, rotation: Rotation = .normal) {
        self.id = id
        self.name = name
        self.seats = []
        self.headSeatsEnabled = headSeatsEnabled
        self.offset = offset
        self.rotation = rotation
        
        for _ in 1 ... numberOfSeats {
            self.seats.append(Seat())
        }
    }
}

// MARK: - Seat
/// The type representing a seat at a table.
struct Seat: Identifiable, Codable, Equatable {
    var id = UUID().uuidString
}

// MARK: - Rotation
extension Table {
    /// The type representing the rotation of the table in turns of 90 degrees.
    enum Rotation: String, Codable, Equatable {
        case normal, up, right, down
        
        var isHorizontal: Bool {
            self == .normal || self == .right
        }
        
        mutating func turnRight() {
            switch self {
                case .normal:
                    self = .up
                case .up:
                    self = .right
                case .right:
                    self = .down
                case .down:
                    self = .normal
            }
        }
        
        mutating func turnLeft() {
            switch self {
                case .normal:
                    self = .down
                case .down:
                    self = .right
                case .right:
                    self = .up
                case .up:
                    self = .normal
            }
        }
    }
}

// MARK: - Seat Positions
extension Table {
    /// The top seats in the normal rotation.
    var topSeats: [Seat] {
        var seats = self.seats
        
        if rightHeadSeat != nil {
            seats.removeLast()
        }
        if leftHeadSeat != nil {
            seats.removeLast()
        }
        
        var topSeats = [Seat]()
        
        for (index, seat) in seats.enumerated() {
            if index % 2 == 0 {
                topSeats.append(seat)
            }
        }
        
        return topSeats
    }
    
    /// The bottom seats in the normal rotation.
    var bottomSeats: [Seat] {
        var seats = self.seats
        
        if rightHeadSeat != nil {
            seats.removeLast()
        }
        if leftHeadSeat != nil {
            seats.removeLast()
        }
        
        var bottomSeats = [Seat]()
        
        for (index, seat) in seats.enumerated() {
            if index % 2 != 0 {
                bottomSeats.append(seat)
            }
        }
        
        return bottomSeats
    }
    
    /// The left seats in the normal rotation.
    var leftHeadSeat: Seat? {
        if headSeatsEnabled && seats.count >= 3 {
            return rightHeadSeat == nil ? seats.last : seats[seats.count - 1 - 1]
        } else {
            return nil
        }
    }
    
    /// The right seats in the normal rotation.
    var rightHeadSeat: Seat? {
        headSeatsEnabled && seats.count >= 4 && seats.count % 2 == 0 ? seats.last : nil
    }
}

// MARK: - Maximum Offset
extension Table {
    /// The maximum distance the center of the table can be from the center of the room.
    static let maximumOffset = CGSize(width: 1000, height: 1000)
}

// MARK: - New
extension Table {
    /// The default values for a new table.
    static func new(_ tableNumber: Int? = nil) -> Table {
        Table(name: "Tisch\(tableNumber != nil ? " \(tableNumber!)" : "")", numberOfSeats: 2, headSeatsEnabled: true)
    }
}

// MARK: - Empty
extension Table {
    /// An empty table with only one seat.
    static let empty = Table(id: UUID().uuidString, name: "", numberOfSeats: 1, headSeatsEnabled: false, offset: .zero, rotation: .normal)
}

// MARK: - Example
extension Table {
    /// An example table with the given properties.
    static func example(seatCount: Int = 4, sideSeats: Bool = true, rotation: Rotation = .normal) -> Table {
        Table(name: "Example \(seatCount) seats", numberOfSeats: seatCount, headSeatsEnabled: sideSeats, rotation: rotation)
    }
}
