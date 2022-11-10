/*
 Abstract:
    Funktion die gegebene Telefonnummer anruft.
 Source:
    https://developer.apple.com/forums/thread/87997
 */

import Foundation
import UIKit

extension UIApplication {
    /// Calls the given phone number.
    func callNumber(_ phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            if canOpenURL(phoneCallURL) {
                open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}
