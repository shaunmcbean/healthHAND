import Foundation
import SwiftUI

class AVSViewModel: ObservableObject {
    @Published var documents: [AVSDocument] = []
    private let documentsKey = "savedDocuments"
    
    init() {
        loadDocuments()
    }
    
    func addDocument(clinicName: String, doctorName: String, imageData: Data) throws {
        let fileName = "\(UUID().uuidString).jpg"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        
        try imageData.write(to: fileURL)
        
        let document = AVSDocument(
            clinicName: clinicName,
            doctorName: doctorName,
            fileName: fileName
        )
        documents.append(document)
        saveDocuments()
    }
    
    func deleteDocument(_ document: AVSDocument) {
        try? FileManager.default.removeItem(at: document.documentURL)
        
        if let index = documents.firstIndex(where: { $0.id == document.id }) {
            documents.remove(at: index)
            saveDocuments()
        }
    }
    
    private func saveDocuments() {
        if let encoded = try? JSONEncoder().encode(documents) {
            UserDefaults.standard.set(encoded, forKey: documentsKey)
        }
    }
    
    private func loadDocuments() {
        if let data = UserDefaults.standard.data(forKey: documentsKey),
           let decoded = try? JSONDecoder().decode([AVSDocument].self, from: data) {
            documents = decoded.filter { FileManager.default.fileExists(atPath: $0.documentURL.path) }
            
            if documents.count != decoded.count {
                saveDocuments()
            }
        }
    }
} 