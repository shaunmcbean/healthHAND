import Foundation

struct AVSDocument: Identifiable, Codable {
    let id: UUID
    let clinicName: String
    let doctorName: String
    let uploadDate: Date
    let fileName: String
    
    init(id: UUID = UUID(), clinicName: String, doctorName: String, uploadDate: Date = Date(), fileName: String) {
        self.id = id
        self.clinicName = clinicName
        self.doctorName = doctorName
        self.uploadDate = uploadDate
        self.fileName = fileName
    }
    
    var documentURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }
} 