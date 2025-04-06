import SwiftUI
import PhotosUI

struct PatientDashboardView: View {
    @StateObject private var viewModel = AVSViewModel()
    @State private var showingDocumentUploader = false
    @State private var showingSettings = false
    
    private var documentsList: some View {
        List {
            ForEach(viewModel.documents) { document in
                NavigationLink {
                    DocumentDetailView(document: document)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(document.clinicName)
                            .font(.headline)
                        Text(document.doctorName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(document.uploadDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deleteDocument(document)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.documents.isEmpty {
                    ContentUnavailableView(
                        "No Documents",
                        systemImage: "doc.text",
                        description: Text("Upload your medical documents to keep track of your visits.")
                    )
                } else {
                    documentsList
                }
            }
            .navigationTitle("Documents")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            showingSettings = true
                        } label: {
                            Image(systemName: "gear")
                        }
                        
                        Button {
                            showingDocumentUploader = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingDocumentUploader) {
                DocumentUploaderView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

struct DocumentDetailView: View {
    let document: AVSDocument
    
    var body: some View {
        ScrollView {
            if let image = UIImage(contentsOfFile: document.documentURL.path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ContentUnavailableView(
                    "Document Not Found",
                    systemImage: "doc.text.fill",
                    description: Text("The document file could not be loaded.")
                )
            }
        }
        .navigationTitle(document.clinicName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DocumentRow: View {
    let document: AVSDocument
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(document.clinicName)
                .font(.headline)
            Text("Dr. \(document.doctorName)")
                .font(.subheadline)
            Text(document.uploadDate.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
} 
