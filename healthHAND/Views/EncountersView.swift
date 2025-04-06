import SwiftUI

struct EncountersView: View {
    @ObservedObject var viewModel: EncounterViewModel
    @State private var selectedEncounter: Encounter?
    
    private var encountersList: some View {
        List {
            ForEach(viewModel.encounters) { encounter in
                Button {
                    selectedEncounter = encounter
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(encounter.clinicName)
                                .font(.headline)
                            Text(encounter.doctorName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(encounter.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.toggleVerification(for: encounter)
                        } label: {
                            Image(systemName: encounter.isVerified ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(encounter.isVerified ? .green : .gray)
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.encounters.isEmpty {
                    ContentUnavailableView(
                        "No Encounters",
                        systemImage: "calendar",
                        description: Text("Your medical visits will appear here.")
                    )
                } else {
                    encountersList
                }
            }
            .navigationTitle("Encounters")
            .sheet(item: $selectedEncounter) { encounter in
                EncounterDetailView(encounter: encounter)
            }
        }
    }
}

struct EncounterDetailView: View {
    let encounter: Encounter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Patient Information
                    GroupBox("Patient Information") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name: \(encounter.patientName)")
                            Text("DOB: \(encounter.patientDOB.formatted(date: .long, time: .omitted))")
                        }
                    }
                    
                    // Visit Information
                    GroupBox("Visit Information") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Chief Complaint:")
                                .font(.headline)
                            Text(encounter.chiefComplaint)
                            
                            Text("Diagnoses:")
                                .font(.headline)
                                .padding(.top, 8)
                            ForEach(encounter.diagnoses, id: \.self) { diagnosis in
                                Text("• \(diagnosis)")
                            }
                        }
                    }
                    
                    // Vitals
                    GroupBox("Vitals") {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Height: \(encounter.height)")
                                Spacer()
                                Text("Weight: \(encounter.weight) lbs")
                            }
                            HStack {
                                Text("Pulse: \(encounter.pulse)")
                                Spacer()
                                Text("BP: \(encounter.bloodPressure)")
                            }
                            HStack {
                                Text("Temp: \(encounter.temperature)°F")
                                Spacer()
                                Text("Pulse Ox: \(encounter.pulseOx)%")
                            }
                            Text("A1C: \(encounter.a1c)")
                            if !encounter.otherData.isEmpty {
                                Text("Other: \(encounter.otherData)")
                            }
                        }
                    }
                    
                    // Summary
                    GroupBox("Visit Summary") {
                        Text(encounter.summary)
                    }
                    
                    // Care Plan
                    GroupBox("Care Plan") {
                        Text(encounter.carePlan)
                    }
                }
                .padding()
            }
            .navigationTitle("Visit Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 