/*
 Abstract:
    Umrechnung von Grad zu Radians und umgekehrt.
 */

import Foundation

// MARK: - Angle Measures
extension Double {
    /// Converts a degree value to the corresponding radian value.
    func convertToRadians() -> Double {
        self * .pi / 180
    }
    
    /// Converts a radian value to the corresponding degree value.
    func convertToDegrees() -> Double {
        self * 180 / .pi
    }
}
