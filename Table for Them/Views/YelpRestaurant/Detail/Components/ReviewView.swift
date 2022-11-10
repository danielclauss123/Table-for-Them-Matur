import SwiftUI

extension YelpRestaurantDetailView {
    struct ReviewView: View {
        let rating: Double
        let reviewCount: Int
        let yelpURL: URL
        
        // MARK: - Body
        var body: some View {
            InsetScrollViewSection(title: "Bewertungen") {
                HStack {
                    VStack(alignment: .leading) {
                        Image(yelpRating: rating)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                        
                        Text("Basierend auf \(reviewCount) Bewertungen")
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Link(destination: yelpURL) {
                        Image.yelpLogo
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                }
            }
        }
    }
}


// MARK: - Previews
struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        YelpRestaurantDetailView.ReviewView(rating: 5, reviewCount: 4, yelpURL: YelpRestaurantDetail.fullExample1.yelpURL)
            .previewLayout(.sizeThatFits)
    }
}
