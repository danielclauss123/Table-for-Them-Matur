import SwiftUI

struct NewRoomView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: NewRoomViewModel
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                Section("Name") {
                    TextField("Raum Name", text: $viewModel.room.name)
                }
            }
            .navigationTitle(viewModel.creatingNewRoom ? "Neuer Raum" : "Raum bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") {
                        viewModel.saveToFirestore()
                        
                        if !viewModel.showingErrorAlert {
                            dismiss()
                        }
                    }
                    .disabled(viewModel.room.name.isEmpty)
                }
            }
            .alert(viewModel.errorMessage ?? "Unbekannter Fehler", isPresented: $viewModel.showingErrorAlert) {
                Button("Ok") { }
            }
        }
        .interactiveDismissDisabled()
    }
    
    // MARK: - Init
    init(viewModel: NewRoomViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
}


// MARK: - Previews
struct NewRoomView_Previews: PreviewProvider {
    static var previews: some View {
        NewRoomView(viewModel: NewRoomViewModel(newRoomNumber: 5))
    }
}
