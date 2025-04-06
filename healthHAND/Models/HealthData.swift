import Foundation

struct HealthData: Codable {
    var heartRate: Int
    var bloodPressure: BloodPressure
    var weight: Int
    var labResults: [LabResult]
    
    struct BloodPressure: Codable {
        var systolic: Int
        var diastolic: Int
        
        var formatted: String {
            "\(systolic)/\(diastolic)"
        }
    }
    
    struct LabResult: Codable, Identifiable {
        let id = UUID()
        var name: String
        var value: Double
        var date: Date
    }
    
    static var mockData: HealthData {
        HealthData(
            heartRate: 72,
            bloodPressure: BloodPressure(systolic: 120, diastolic: 80),
            weight: 172,
            labResults: [
                LabResult(name: "Cholesterol", value: 185, date: Date()),
                LabResult(name: "Blood Sugar", value: 95, date: Date()),
                LabResult(name: "Vitamin D", value: 45, date: Date()),
                LabResult(name: "Iron", value: 80, date: Date())
            ]
        )
    }
} 