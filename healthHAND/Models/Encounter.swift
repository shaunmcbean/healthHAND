import Foundation

struct Encounter: Identifiable, Codable {
    let id: UUID
    let clinicName: String
    let doctorName: String
    let date: Date
    var isVerified: Bool
    
    // Patient Information
    let patientName: String
    let patientDOB: Date
    
    // Visit Information
    let chiefComplaint: String
    let diagnoses: [String]
    
    // Vitals
    let height: String
    let weight: Int
    let pulse: Int
    let bloodPressure: String
    let temperature: Double
    let pulseOx: Int
    let a1c: Double
    let otherData: String
    
    // Visit Summary
    let summary: String
    let carePlan: String
    
    init(clinicName: String, 
         doctorName: String, 
         date: Date, 
         patientName: String,
         patientDOB: Date,
         chiefComplaint: String,
         diagnoses: [String],
         height: String,
         weight: Int,
         pulse: Int,
         bloodPressure: String,
         temperature: Double,
         pulseOx: Int,
         a1c: Double,
         otherData: String,
         summary: String,
         carePlan: String,
         isVerified: Bool = false) {
        self.id = UUID()
        self.clinicName = clinicName
        self.doctorName = doctorName
        self.date = date
        self.patientName = patientName
        self.patientDOB = patientDOB
        self.chiefComplaint = chiefComplaint
        self.diagnoses = diagnoses
        self.height = height
        self.weight = weight
        self.pulse = pulse
        self.bloodPressure = bloodPressure
        self.temperature = temperature
        self.pulseOx = pulseOx
        self.a1c = a1c
        self.otherData = otherData
        self.summary = summary
        self.carePlan = carePlan
        self.isVerified = isVerified
    }
} 