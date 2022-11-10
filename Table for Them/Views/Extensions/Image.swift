/*
 Abstract:
    Standart Placeholder für AsyncImage.
    Yelp Rating Images.
 */

import SwiftUI

// MARK: - Placeholder
extension Image {
    /// The default placeholder for an async image.
    static func defaultPlaceholder(_ color: Color = Color(uiColor: .secondarySystemBackground)) -> some View {
        ZStack {
            color
            
            Image(systemName: "photo")
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Yelp
extension Image {
    /// An image with the corresponding yelp rating from 1 to 5.
    init(yelpRating: Double) {
        guard yelpRating >= 0 && yelpRating <= 5 else {
            self.init("regular_0")
            return
        }
        
        let integerRating = Int(yelpRating)
        let addingPointFive = yelpRating > Double(integerRating)
        
        self.init("extra_large_\(integerRating)\(addingPointFive ? "_half" : "")")
    }
    
    /// The yelp logo with the company name.
    static let yelpLogo = Image("yelpLogo")
    /// The yelp burst without the name.
    static let yelpBurst = Image("yelpBurst")
}
