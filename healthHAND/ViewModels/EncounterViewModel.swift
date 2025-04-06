import Foundation

class EncounterViewModel: ObservableObject {
    @Published var encounters: [Encounter] = []
    private let encountersKey = "savedEncounters"
    
    init() {
        loadEncounters()
    }
    
    func parseDocumentAndCreateEncounter(from document: AVSDocument) {
        // This is a placeholder for actual document parsing
        // In a real app, you would use OCR or other methods to extract this information
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let encounter = Encounter(
            clinicName: document.clinicName,
            doctorName: document.doctorName,
            date: document.uploadDate,
            patientName: "Jane Doe",
            patientDOB: dateFormatter.date(from: "01/01/1960") ?? Date(),
            chiefComplaint: "Diabetes management, hypertension management, pain when urinating",
            diagnoses: ["Urinary tract infection", "Diabetes", "Hypertension"],
            height: "5'2\"",
            weight: 158,
            pulse: 102,
            bloodPressure: "122/74",
            temperature: 97.5,
            pulseOx: 91,
            a1c: 7.0,
            otherData: "Urinalysis positive for nitrites and leukocytes (70+)",
            summary: "Thank you for coming in. Today, we spoke about the burning you have been experiencing while urinating. We analyzed your urine on-site and it suggests you have an infection in your urinary tract. We will send your urine sample to a lab for more testing to identify the specific bacteria. We also took your A1C, which is a measurement of the sugar levels in your blood in the past 3 months. Your A1C is 7.0. We hope to lower this a bit to prevent future issues. Overall, we believe you have a urinary tract infection, and also hope to lower your blood sugar levels.",
            carePlan: "Take Cephalexin (500mg) two times a day for 5 days for urinary tract infection."
        )
        
        encounters.append(encounter)
        saveEncounters()
    }
    
    func toggleVerification(for encounter: Encounter) {
        if let index = encounters.firstIndex(where: { $0.id == encounter.id }) {
            encounters[index].isVerified.toggle()
            saveEncounters()
        }
    }
    
    private func saveEncounters() {
        if let encoded = try? JSONEncoder().encode(encounters) {
            UserDefaults.standard.set(encoded, forKey: encountersKey)
        }
    }
    
    private func loadEncounters() {
        if let data = UserDefaults.standard.data(forKey: encountersKey),
           let decoded = try? JSONDecoder().decode([Encounter].self, from: data) {
            encounters = decoded
        }
    }
} 