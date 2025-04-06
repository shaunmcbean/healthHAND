import Foundation

struct AVSDocument: Identifiable, Codable {
    let id: UUID
    let clinicName: String
    let doctorName: String
    let fileName: String
    let uploadDate: Date
    var isVerified: Bool
    
    var documentURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }
    
    init(clinicName: String, doctorName: String, fileName: String) {
        self.id = UUID()
        self.clinicName = clinicName
        self.doctorName = doctorName
        self.fileName = fileName
        self.uploadDate = Date()
        self.isVerified = false // All new documents start as unverified
    }
} 