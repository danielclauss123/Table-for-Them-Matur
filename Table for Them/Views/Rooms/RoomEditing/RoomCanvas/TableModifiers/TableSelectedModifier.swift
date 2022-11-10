import SwiftUI

/// Displays a border around the table if it is selected.
struct TableSelectedModifier: ViewModifier {
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        Group {
            if isSelected {
                content
                    .padding(5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.accentColor, lineWidth: 2)
                    }
            } else {
                content
            }
        }
    }
}

extension View {
    /// Displays a border around the table if it is selected.
    func tableSelected(_ isSelected: Bool) -> some View {
        modifier(TableSelectedModifier(isSelected: isSelected))
    }
}

struct TableSelectedModifier_Previews: PreviewProvider {
    static var previews: some View {
        TableView(table: .example(), seatFill: Color.blue, tableFill: Color.indigo)
            .tableSelected(true)
    }
}
