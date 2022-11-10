import SwiftUI

// MARK: - Protocol
/// A Protocol for any type of opening hours.
protocol Hours: Codable, Hashable {
    var start: String { get }
    var end: String { get }
    var isOvernight: Bool { get }
}

// MARK: - Extension
extension Hours {
    var startTime: Date? {
        Date(fromMilitaryTimeString: start)
    }
    
    var endTime: Date? {
        Date(fromMilitaryTimeString: end)
    }
    
    /// A string representation like "18:00 - 20:00".
    var text: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let startText = startTime != nil ? formatter.string(from: startTime!) : "Unbekannt"
        let endText = endTime != nil ? formatter.string(from: endTime!) : "Unbekannt"
        
        return "\(startText) - \(endText)"
    }
}

// MARK: - Conforming Types
/// The opening hours for one normal day.
struct DayHours: Hours {
    let isOvernight: Bool
    let start: String
    let end: String
    let day: Int
    
    var weekday: Weekday {
        Weekday(rawValue: day) ?? .unknown
    }
}

/// The opening hours for a special day.
struct SpecialHours: Hours {
    let date: String
    let isOvernight: Bool
    let isClosed: Bool?
    let start: String
    let end: String
    
    var dateOfDay: Date {
        (try? Date(date, strategy: .iso8601)) ?? Date(timeIntervalSince1970: 0)
    }
}
