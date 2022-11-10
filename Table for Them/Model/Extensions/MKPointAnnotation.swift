/*
 Abstract:
    Initializer für alle properties.
    Empty Annotation.
 */

import Foundation
import MapKit

// MARK: - Initializer
extension MKPointAnnotation {
    /// A quick initializer to create the annotation.
    convenience init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
        self.init()
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

// MARK: - Empty
extension MKPointAnnotation {
    /// An empty annotation.
    static let empty = MKPointAnnotation()
}
