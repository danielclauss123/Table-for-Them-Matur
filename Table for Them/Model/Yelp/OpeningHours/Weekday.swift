import SwiftUI

enum Weekday: Int, Identifiable, CaseIterable {
    case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday, unknown
    
    /// Creates a day from the apple way of counting weekdays.
    ///
    /// Apple starts the week with sunday and an index of 1, which is very difficult.
    init?(appleWeekday: Int) {
        let day = appleWeekday > 1 ? appleWeekday - 2 : 7 - appleWeekday
        
        self.init(rawValue: day)
    }
    
    /// Id for Identifiable conformance.
    var id: Weekday {
        self
    }
    
    /// The name of the weekday as a string.
    var name: String {
        switch self {
        case .monday:
            return "Montag"
        case .tuesday:
            return "Dienstag"
        case .wednesday:
            return "Mittwoch"
        case .thursday:
            return "Donnerstag"
        case .friday:
            return "Freitag"
        case .saturday:
            return "Samstag"
        case .sunday:
            return "Sonntag"
        case .unknown:
            return "Unbekannt"
        }
    }
    
    /// Weekday of today.
    static var today: Weekday {
        let appleWeekday = Calendar.current.component(.weekday, from: Date.now)
        
        return Weekday(appleWeekday: appleWeekday) ?? .unknown
    }
}
