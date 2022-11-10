import SwiftUI

struct TableEditingSheet: View {
    @Binding var selectedTableId: String?
    
    @ObservedObject var viewModel: RoomEditingViewModel
    
    var insetHeightUpdate: (Double) -> Void
    
    @State private var sheetStatus = BottomSheetStatus.hidden
    
    var tableIndex: Int? {
        viewModel.room.tables.firstIndex(where: { $0.id == selectedTableId.unwrapWithUUID() })
    }
    
    var numberOfSeatsBinding: Binding<Int> {
        Binding<Int> {
            guard let tableIndex = tableIndex else {
                return 0
            }
            
            return viewModel.room.tables[tableIndex].seats.count
        } set: {
            guard let tableIndex = tableIndex else {
                return
            }
            
            if $0 > viewModel.room.tables[tableIndex].seats.count {
                viewModel.room.tables[tableIndex].seats.append(Seat())
            } else if viewModel.room.tables[tableIndex].seats.count >= 2 {
                viewModel.room.tables[tableIndex].seats.removeLast()
            }
            
            viewModel.room.setSize()
        }
    }
    
    // MARK: - Body
    var body: some View {
        BottomSheet(sheetStatus: $sheetStatus, background: Color(uiColor: .secondarySystemBackground), heightsAfterStatusUpdate: { status, heights in
            switch status {
                case .up:
                    insetHeightUpdate(heights.middle)
                case .middle:
                    insetHeightUpdate(heights.middle)
                case .down:
                    insetHeightUpdate(heights.down)
                case .hidden:
                    insetHeightUpdate(0)
            }
        }) {
            header
        } content: {
            content
        }
        .task {
            if selectedTableId == nil {
                sheetStatus = .hidden
            } else {
                sheetStatus = .middle
            }
        }
        .onChange(of: selectedTableId) { newValue in
            if newValue == nil {
                sheetStatus = .hidden
            } else {
                sheetStatus = .middle
            }
        }
    }
    
    // MARK: - Header
    var header: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    selectedTableId = nil
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(7)
                        .background(.quaternary)
                        .clipShape(Circle())
                }
                .foregroundColor(.primary)
            }
            .padding(.bottom, 5)
            
            HStack {
                Button {
                    if let tableIndex = tableIndex {
                        viewModel.room.tables[tableIndex].rotation.turnLeft()
                        viewModel.room.setSize()
                    }
                } label: {
                    Image(systemName: "rotate.left")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            Color(uiColor: .systemBackground)
                        }
                        .cornerRadius(10)
                }
                
                Button {
                    if let tableIndex = tableIndex {
                        viewModel.room.tables[tableIndex].rotation.turnRight()
                        viewModel.room.setSize()
                    }
                } label: {
                    Image(systemName: "rotate.right")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            Color(uiColor: .systemBackground)
                        }
                        .cornerRadius(10)
                }
            }
        }
    }
    
    // MARK: - Content
    var content: some View {
        Form {
            if let tableIndex = tableIndex {
                Section("Name") {
                    TextField("Tisch Name", text: $viewModel.room.tables[tableIndex].name)
                }
                
                Section {
                    Stepper("\(viewModel.room.tables[tableIndex].seats.count) Stühle", value: numberOfSeatsBinding, in: 1 ... 20)
                    
                    Toggle("Stühle auf den Seiten", isOn: $viewModel.room.tables[tableIndex].headSeatsEnabled)
                } header: {
                    Text("Stühle")
                } footer: {
                    VStack {
                        Text("Der Tisch kann bewegt werden, indem man ihn lange drückt und dann verschiebt.")
                    }
                }
                
                Button("Löschen", role: .destructive) {
                    sheetStatus = .hidden
                    viewModel.room.tables.remove(at: tableIndex)
                    viewModel.room.setSize()
                }
            }
        }
    }
}


// MARK: - Previews
struct TableEditingSheet_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                TableEditingSheet(selectedTableId: .constant(Room.examples[0].tables[0].id), viewModel: .example, insetHeightUpdate: { _ in })
            }
            .tabItem {
                Label("Item", systemImage: "trash")
            }
        }
    }
}
