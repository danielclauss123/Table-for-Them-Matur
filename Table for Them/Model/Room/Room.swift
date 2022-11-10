/*
 static let seatFill = Color.blue
 static let tableFill = LinearGradient(colors: [.indigo, .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
 */

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

/// The type for a room, that holds all the tables inside of the room and the room size.
struct Room: Identifiable, Codable {
    @DocumentID var id: String?
    
    var name: String
    var tables: [Table]
    var size: CGSize
    
    /// Initializes the room and sets its size according to the given tables if the size is zero.
    init(id: String = UUID().uuidString, name: String = "Raum", tables: [Table] = [], size: CGSize = .zero) {
        self.id = id
        self.name = name
        self.tables = tables
        self.size = size
        
        if size == .zero {
            setSize()
        }
    }
    
    /// Sets the room size according to the table offsets.
    ///
    /// The maximum offset in the width and height direction times two is the width / height of the room.
    /// There is also an addition of 100 to the size so that the tables have room at their sides.
    mutating func setSize() {
        size.width = tables.reduce(into: 0.0) { currentMax, table in
            let roomWidth = abs(table.offset.width * 2) + (table.rotation.isHorizontal ? table.width : table.height)
            
            if roomWidth + 100 > currentMax {
                currentMax = roomWidth + 100
            }
        }
        
        size.height = tables.reduce(into: 0.0) { currentMax, table in
            let roomHeight = abs(table.offset.height * 2) + (table.rotation.isHorizontal ? table.height : table.width)
            
            if roomHeight + 100 > currentMax {
                currentMax = roomHeight + 100
            }
        }
    }
}

// MARK: - UI Functions
extension Room {
    /// Returns the perfect scale to show the room so it fits perfectly in the given rectangle.
    ///
    /// The scale is the value applied in the scale affect. You could call it zoom.
    func perfectScale(inGeometry geometry: GeometryProxy) -> Double {
        let scaleToFitWidth = geometry.size.width / size.width
        
        if scaleToFitWidth * size.height <= geometry.size.height {
            // The full width can be filled and there is some or exactly no height to spare.
            return scaleToFitWidth
        } else {
            // The width cannot be filled because then the height would be outside of the container.
            return geometry.size.height / size.height
        }
    }
}

// MARK: - New
extension Room {
    /// The default values for a new room.
    static func new(_ roomNumber: Int? = nil) -> Room {
        Room(name: "Raum\(roomNumber != nil ? " \(roomNumber!)" : "")", tables: [Table.new(1)])
    }
}

// MARK: - Example
extension Room {
    /// An array of two example rooms.
    static var examples: [Room] {
        [Room(tables: [.example(), .example(), .example()]), Room(name: "Room 2", tables: [.example(), .example(), .example()])]
    }
}
