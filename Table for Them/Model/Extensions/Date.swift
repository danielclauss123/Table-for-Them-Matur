/*
 Abstract:
    Date Initializer mit Zeit als "0930" String.
 */

import Foundation

extension Date {
    /// Creates a date from a string like "0930"
    ///
    /// A string of "0930" would make a date with the hours value of 9 and the minutes value of 30.
    init?(fromMilitaryTimeString timeString: String) {
        guard timeString.count == 4 else {
            return nil
        }
        
        guard let timeInt = Int(timeString) else {
            return nil
        }
        
        let hour = timeInt / 100
        let minute = timeInt - hour * 100
        
        let components = DateComponents(hour: hour, minute: minute)
        guard let date = Calendar.current.date(from: components) else {
            return nil
        }
        
        self.init()
        self = date
    }
}
