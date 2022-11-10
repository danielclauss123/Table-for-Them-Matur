import SwiftUI

extension View {
    func listTopErrorMessage(_ text: String) -> some View {
        safeAreaInset(edge: .top) {
            if !text.isEmpty {
                VStack(spacing: 0) {
                    Divider()
                    
                    Text(text)
                        .bold()
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            Color.red
                                .overlay(.regularMaterial)
                        }
                }
            }
        }
    }
}
