import SwiftUI

struct ShortRatingView: View {
    var rating: Double
    var reviewCount: Int? = nil
    
    var systemImage: String = "star.fill"
    
    var body: some View {
        Text("\(Image(systemName: systemImage))\(rating, specifier: "%.1f")")
            .foregroundColor(.yellow)
            .bold()
        +
        Text(reviewCount != nil ? " (\(reviewCount ?? 0))" : "")
            .foregroundColor(.secondary)
    }
}


// MARK: - Previews
struct ShortRatingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ShortRatingView(rating: 3.5)
                .previewLayout(.sizeThatFits)
            ShortRatingView(rating: 3.5, reviewCount: 20)
                .previewLayout(.sizeThatFits)
        }
    }
}
