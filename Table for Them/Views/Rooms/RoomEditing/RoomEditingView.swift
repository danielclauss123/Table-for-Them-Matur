import SwiftUI

struct RoomEditingView: View {
    @StateObject var viewModel: RoomEditingViewModel
    
    @State private var editing = false
    
    // MARK: - Body
    var body: some View {
        RoomCanvasView(viewModel: viewModel, editingEnabled: editing)
            .navigationTitle(viewModel.room.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(editing)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(editing ? "Fertig" : "Bearbeiten") {
                        if editing {
                            viewModel.saveToFirebase()
                            if !viewModel.showingErrorAlert {
                                editing = false
                            }
                        } else {
                            editing = true
                        }
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    if editing {
                        Button("Abbrechen") {
                            viewModel.resetToLastSaved()
                            editing = false
                        }
                    }
                }
            }
            .alert(viewModel.errorMessage ?? "Unbekannter Fehler", isPresented: $viewModel.showingErrorAlert) {
                Button("Ok") { }
            }
    }
    
    // MARK: - Init
    init(room: Room) {
        self._viewModel = StateObject(wrappedValue: RoomEditingViewModel(room: room))
    }
}


// MARK: - Previews
struct RoomEditingView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationView {
                RoomEditingView(room: .examples[0])
            }
            .tabItem {
                Label("Example", systemImage: "trash")
            }
        }
        .previewInterfaceOrientation(.portrait)
    }
}
