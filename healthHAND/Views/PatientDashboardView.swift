import SwiftUI
import PhotosUI

struct PatientDashboardView: View {
    @StateObject private var viewModel = AVSViewModel()
    @State private var showingDocumentUploader = false
    
    private var documentsList: some View {
        List {
            ForEach(viewModel.documents) { document in
                NavigationLink {
                    DocumentDetailView(document: document)
                } label: {
                    HStack {
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
                        
                        Spacer()
                        
                        Image(systemName: document.isVerified ? "checkmark.seal.fill" : "xmark.seal.fill")
                            .foregroundStyle(document.isVerified ? .green : .gray)
                            .font(.title2)
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
        }
    }
}

struct DocumentDetailView: View {
    let document: AVSDocument
    
    var body: some View {
        ScrollView {
            VStack {
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
                
                HStack {
                    Image(systemName: document.isVerified ? "checkmark.seal.fill" : "xmark.seal.fill")
                        .foregroundStyle(document.isVerified ? .green : .gray)
                        .font(.title)
                    Text(document.isVerified ? "Verified" : "Not Verified")
                        .font(.headline)
                        .foregroundStyle(document.isVerified ? .green : .gray)
                }
                .padding()
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
