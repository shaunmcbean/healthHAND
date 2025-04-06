import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = AVSViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "heart.text.square.fill")
                }
                .tag(0)
            
            PatientDashboardView()
                .tabItem {
                    Label("Documents", systemImage: "doc.text")
                }
                .tag(1)
            
            AIAssistantView()
                .tabItem {
                    Label("Assistant", systemImage: "brain.head.profile")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
    }
} 