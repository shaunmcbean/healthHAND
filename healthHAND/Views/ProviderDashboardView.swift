import SwiftUI

struct ProviderDashboardView: View {
    @ObservedObject var viewModel: AVSViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ContentUnavailableView(
                    "Provider Features Coming Soon",
                    systemImage: "stethoscope",
                    description: Text("Future updates will include provider-specific features")
                )
            }
            .navigationTitle("Provider Dashboard")
        }
    }
} 