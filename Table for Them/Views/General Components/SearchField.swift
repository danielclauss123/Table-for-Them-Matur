import SwiftUI

/// A TextField that looks like a search field.
struct SearchField: View {
    let placeholder: String
    
    let systemImage: String?
    let backgroundColor: Color
    
    @Binding var text: String
    
    let onEditingChanged: (Bool) -> Void
 
    @State private var isEditing = false
    
    // MARK: - Body
    var body: some View {
        HStack {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .foregroundColor(.secondary)
            }
            
            TextField(placeholder, text: $text) {
                isEditing = $0
                onEditingChanged($0)
            }
            
            if !text.isEmpty && isEditing {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(backgroundColor)
        .cornerRadius(10)
    }
    
    // MARK: - Initializer
    init(_ placeholder: String = "Suche", systemImage: String? = nil, backgroundColor: Color = Color(uiColor: .systemBackground), text: Binding<String>, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.placeholder = placeholder
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
        self._text = text
        self.onEditingChanged = onEditingChanged
    }
}


// MARK: - Previews
struct SearchField_Previews: PreviewProvider {
    struct Container: View {
        @State private var state = ""
        
        var body: some View {
            ZStack {
                Color(uiColor: .secondarySystemBackground)
                    .ignoresSafeArea()
                
                SearchField("Search Text", systemImage: "magnifyingglass", text: $state)
                    .padding()
            }
        }
    }
    
    static var previews: some View {
        Container()
    }
}
