import SwiftUI
import PhotosUI

struct DocumentUploaderView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AVSViewModel
    
    @State private var clinicName = ""
    @State private var doctorName = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private var isFormValid: Bool {
        !clinicName.isEmpty && !doctorName.isEmpty && selectedImageData != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Document Details") {
                    TextField("Clinic Name", text: $clinicName)
                        .textInputAutocapitalization(.words)
                    TextField("Doctor Name", text: $doctorName)
                        .textInputAutocapitalization(.words)
                }
                
                Section("Document") {
                    PhotosPicker(selection: $selectedItem,
                               matching: .images,
                               photoLibrary: .shared()) {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            ContentUnavailableView("Select Document", 
                                systemImage: "doc.badge.plus",
                                description: Text("Tap to choose a document from your photos"))
                        }
                    }
                }
            }
            .navigationTitle("Upload Document")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveDocument()
                    }
                    .disabled(!isFormValid)
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func saveDocument() {
        guard let imageData = selectedImageData else { return }
        
        do {
            try viewModel.addDocument(
                clinicName: clinicName,
                doctorName: doctorName,
                imageData: imageData
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
} 