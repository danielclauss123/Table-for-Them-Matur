import SwiftUI

extension YelpRestaurantDetailView {
    struct CreditView: View {
        let yelpURL: URL
        
        // MARK: - Body
        var body: some View {
            VStack(alignment: .leading) {
                Text("Die Restaurant Informationen wurden von Yelp zur verfügung gestellt.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                Link("Mehr auf Yelp", destination: yelpURL)
                    .font(.subheadline.bold())
            }
        }
    }
}

// MARK: - Previews
struct CreditView_Previews: PreviewProvider {
    static var previews: some View {
        YelpRestaurantDetailView.CreditView(yelpURL: YelpRestaurantDetail.fullExample1.yelpURL)
            .previewLayout(.sizeThatFits)
    }
}
