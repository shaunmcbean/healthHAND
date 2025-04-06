import SwiftUI
import Charts

struct DashboardView: View {
    // Using mock data for now
    let healthData = HealthData.mockData
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Medical Symbol and Title
                    HStack {
                        Image(systemName: "staroflife.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.blue)
                        
                        Text("HEALTH DATA")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Vital Signs Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        VitalCard(
                            title: "Heart Rate",
                            value: "\(healthData.heartRate)",
                            unit: "bpm",
                            icon: "heart.fill",
                            color: .red,
                            valueSize: 28
                        )
                        
                        VitalCard(
                            title: "Blood Pressure",
                            value: healthData.bloodPressure.formatted,
                            unit: "mmHg",
                            icon: "waveform.path.ecg",
                            color: .blue,
                            valueSize: 24
                        )
                        
                        VitalCard(
                            title: "Weight",
                            value: "\(healthData.weight)",
                            unit: "lb",
                            icon: "scalemass.fill",
                            color: .green,
                            valueSize: 28
                        )
                    }
                    .padding(.horizontal)
                    
                    // Lab Results Chart
                    GroupBox("Lab Results") {
                        Chart(healthData.labResults) { result in
                            BarMark(
                                x: .value("Test", result.name),
                                y: .value("Value", result.value)
                            )
                            .foregroundStyle(.blue.gradient)
                        }
                        .frame(height: 200)
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct VitalCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    let valueSize: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline)
            }
            
            HStack(alignment: .firstTextBaseline) {
                Text(value)
                    .font(.system(size: valueSize, weight: .bold))
                Text(unit)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
} 