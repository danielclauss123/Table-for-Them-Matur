import SwiftUI

/// The normal opening hours of a restaurant.
struct OpeningHours: Codable, Equatable {
    let isOpenNow: Bool
    let open: [DayHours]
    
    var todaysHours: [DayHours] {
        hours(forWeekday: Weekday.today)
    }
    
    func hours(forWeekday weekday: Weekday) -> [DayHours] {
        open.filter { $0.weekday == weekday }
    }
}
