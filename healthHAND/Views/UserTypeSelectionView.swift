import SwiftUI

struct UserTypeSelectionView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Image(systemName: "doc.text.viewfinder")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                
                Text("Health In Hand")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Keep track of your medical documents")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                NavigationLink {
                    PatientDashboardView()
                } label: {
                    HStack {
                        Image(systemName: "arrow.forward.circle.fill")
                        Text("Get Started")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }
} 