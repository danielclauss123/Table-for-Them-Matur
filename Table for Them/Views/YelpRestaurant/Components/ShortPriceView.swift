import SwiftUI

struct ShortPriceView: View {
    var price: Int
    
    var priceSymbol: String = "$"
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1 ..< 5) { index in
                Text(priceSymbol)
                    .foregroundColor(index > price ? .secondary : .primary)
                    .bold()
            }
        }
    }
}


// MARK: - Previews
struct ShortPriceView_Previews: PreviewProvider {
    static var previews: some View {
        ShortPriceView(price: 3)
            .previewLayout(.sizeThatFits)
    }
}
