import SwiftUI

/// A Stack that can be set to horizontal or vertical dynamically.
///
/// This is handy when the orientation should change based on user action.
struct DynamicalStack<Content: View>: View {
    let axis: Axis.Set
    
    let alignment: Alignment
    let spacing: CGFloat?
    
    let content: () -> Content
    
    // MARK: - Body
    var body: some View {
        if axis == .horizontal {
            HStack(alignment: alignment.vertical, spacing: spacing, content: content)
        } else {
            VStack(alignment: alignment.horizontal, spacing: spacing, content: content)
        }
    }
    
    // MARK: - Init
    init(_ axis: Axis.Set, alignment: Alignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
}


// MARK: - Previews
struct DynamicalStack_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
    
    struct Container: View {
        @State private var isHorizontal = true
        
        var body: some View {
            DynamicalStack(isHorizontal ? .horizontal : .vertical) {
                Text("Hello")
                Text("Swiftui")
                Button("Tap me") {
                    isHorizontal.toggle()
                }
            }
        }
    }
}
