import SwiftUI

/// Lets the table be dragged and meanwhile offset by the drag amount.
///
/// The drag gesture only activates after some time.
struct TableDragAndOffsetModifier: ViewModifier {
    @Binding var table: Table
    
    @State private var lastSetOffset: CGSize
    
    let onEnded: () -> Void
    
    @State private var isDragging = false
    
    func body(content: Content) -> some View {
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        
        let dragGesture = DragGesture()
            .onChanged { value in
                table.offset.width = max(min(value.translation.width + lastSetOffset.width, Table.maximumOffset.width), -Table.maximumOffset.width)
                table.offset.height = max(min(value.translation.height + lastSetOffset.height, Table.maximumOffset.height), -Table.maximumOffset.height)
            }
            .onEnded { _ in
                lastSetOffset = table.offset
                isDragging = false
                onEnded()
            }
        
        let combined = pressGesture.sequenced(before: dragGesture)
        
        content
            .opacity(isDragging ? 0.5 : 1)
            .offset(table.offset)
            .gesture(combined)
    }
    
    init(table: Binding<Table>, onEnded: @escaping () -> Void = { }) {
        self._table = table
        self.lastSetOffset = table.wrappedValue.offset
        
        self.onEnded = onEnded
    }
}

/// Lets the table be dragged and meanwhile offset by the drag amount.
///
/// The drag gesture only activates after some time.
extension View {
    func tableDragAndOffset(table: Binding<Table>, onEnded: @escaping () -> Void = { }) -> some View {
        modifier(TableDragAndOffsetModifier(table: table, onEnded: onEnded))
    }
}
