import SwiftUI

struct RoomCanvasView: View {
    @ObservedObject var viewModel: RoomEditingViewModel
    
    var editingEnabled: Bool
    
    @State private var scale = 1.0
    @State private var bottomSheetInset = 0.0
    
    @State private var selectedTableId: String?
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            canvas
            
            if editingEnabled {
                newTableButton
            }
            
            TableEditingSheet(selectedTableId: $selectedTableId, viewModel: viewModel) { insetHeight in
                withAnimation(.bottomSheet) {
                    bottomSheetInset = insetHeight
                }
            }
        }
        .onChange(of: editingEnabled) { newValue in
            if !newValue {
                selectedTableId = nil
            }
        }
    }
    
    // MARK: - Canvas
    var canvas: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical]) {
                VStack {
                    ZStack {
                        ForEach($viewModel.room.tables) { $table in
                            if editingEnabled {
                                TableView(table: table, seatFill: Color.blue, tableFill: Color.indigo)
                                    .tableSelected(table.id == selectedTableId.unwrapWithUUID())
                                    .onTapGesture {
                                        selectedTableId = table.id
                                    }
                                    .tableDragAndOffset(table: $table) {
                                        viewModel.room.setSize()
                                    }
                                    .scaleEffect(scale)
                            } else {
                                TableView(table: table, seatFill: Color.blue, tableFill: Color.indigo)
                                    .offset(table.offset)
                                    .scaleEffect(scale)
                            }
                        }
                    }
                    .frame(width: viewModel.room.size.width * scale, height: viewModel.room.size.height * scale)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray, lineWidth: 2)
                    }
                    
                    // Gives Space for the things hidden under the EditingSheet.
                    Spacer()
                        .frame(height: bottomSheetInset)
                }
            }
            .magnificationGesture(scale: $scale, maximumScale: 5, minimumScale: 0.2)
            .task {
                scale = viewModel.room.perfectScale(inGeometry: geometry)
            }
        }
    }
    
    // MARK: - New Table Button
    var newTableButton: some View {
        VStack {
            Button {
                let newTable = Table.new(viewModel.room.tables.count + 1)
                
                viewModel.room.tables.append(newTable)
                
                selectedTableId = newTable.id
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .padding(12)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(Circle())
                    .padding()
            }
            
            // Moves it up so it isn't covered by the editing sheet.
            Spacer()
                .frame(height: bottomSheetInset)
        }
    }
}


// MARK: - Previews
struct RoomCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        RoomCanvasView(viewModel: .example, editingEnabled: true)
    }
}
