import SwiftUI

extension YelpRestaurantDetailView {
    struct PhotosView: View {
        let photoURLs: [String]
        
        // MARK: - Body
        var body: some View {
            if photoURLs.isEmpty {
                Image.defaultPlaceholder()
                    .font(.largeTitle)
                    .aspectRatio(4 / 3, contentMode: .fit)
                    .cornerRadius(10)
                    .padding([.horizontal, .top])
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(photoURLs, id: \.self) { photoURL in
                            AsyncImage(url: URL(string: photoURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Image.defaultPlaceholder()
                                    .font(.largeTitle)
                                    .aspectRatio(4 / 3, contentMode: .fit)
                            }
                            .frame(height: 270)
                            .cornerRadius(10)
                        }
                    }
                    .padding([.horizontal, .top])
                }
            }
        }
    }
}


// MARK: - Previews
struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        YelpRestaurantDetailView.PhotosView(photoURLs: YelpRestaurantDetail.fullExample1.photos ?? [])
            .previewLayout(.sizeThatFits)
    }
}
