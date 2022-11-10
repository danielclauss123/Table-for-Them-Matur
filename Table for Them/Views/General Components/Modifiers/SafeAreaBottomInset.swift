import SwiftUI

extension View {
    /// Places a view as a safe area bottom inset with a divider and the regular background.
    func safeAreaBottomInset<InsetContent: View>(@ViewBuilder insetContent: @escaping () -> InsetContent) -> some View {
        safeAreaInset(edge: .bottom) {
            VStack {
                Divider()
                
                insetContent()
            }
            .background(.regularMaterial)
        }
    }
}


// MARK: - Previews
struct SafeAreaBottomInset_Previews: PreviewProvider {
    static var previews: some View {
        Color.blue
            .ignoresSafeArea()
            .safeAreaBottomInset {
                Text("asdfasdfasf")
            }
    }
}
