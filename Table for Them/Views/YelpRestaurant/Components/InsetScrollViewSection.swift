import SwiftUI

/// A scroll view section that is inset and has a large title like in the maps app.
struct InsetScrollViewSection<Content: View>: View {
    let title: String
    
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.primary)
            
            content()
                .frame(maxWidth: .infinity)
                .padding(15)
                .background {
                    Color(uiColor: .systemBackground)
                }
                .cornerRadius(10)
        }
    }
}


// MARK: - Previews
struct InsetScrollViewSection_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                InsetScrollViewSection(title: "Title") {
                    Text("Content")
                }
                .padding()
            }
        }
    }
}
