import SwiftUI
import GoogleGenerativeAI

//
//  ContentView.swift
//  ChatWithGemini
//
//  Created by Etisha Garg on 03/05/24.
//

struct AIAssistantView: View {
    @State private var userInput = ""
    @State private var messages: [(isUser: Bool, text: LocalizedStringKey)] = [
        (isUser: false, text: "Hi, how can I help you today?")
    ]
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    private let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("HiH Assistant")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentColor)
                    .padding(.top, 40)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages.indices, id: \.self) { index in
                            MessageBubble(
                                text: messages[index].text,
                                isUser: messages[index].isUser
                            )
                        }
                    }
                    .padding()
                }
                
                Divider()
                
                HStack {
                    TextField("Ask me anything...", text: $userInput)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isLoading)
                    
                    Button {
                        Task {
                            await sendMessage()
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.accentColor))
                                .scaleEffect(1.2)
                        } else {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title)
                                .foregroundStyle(userInput.isEmpty ? Color(.systemGray3) : Color.accentColor)
                        }
                    }
                    .disabled(userInput.isEmpty || isLoading)
                }
                .padding()
            }
            .navigationTitle("Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
            .alert("Connection Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func sendMessage() async {
        let userMessage = userInput
        userInput = ""
        messages.append((isUser: true, text: LocalizedStringKey(userMessage)))
        isLoading = true
        
        do {
            let response = try await model.generateContent(userMessage)
            if let text = response.text {
                messages.append((isUser: false, text: LocalizedStringKey(text)))
            } else {
                showError(message: "No response received from the assistant")
            }
        } catch let error as NSError {
            if error.domain == NSURLErrorDomain {
                switch error.code {
                case NSURLErrorNotConnectedToInternet:
                    showError(message: "Please check your internet connection")
                case NSURLErrorTimedOut:
                    showError(message: "Request timed out. Please try again")
                case NSURLErrorNetworkConnectionLost:
                    showError(message: "Connection lost. Please try again")
                default:
                    showError(message: "Network error: \(error.localizedDescription)")
                }
            } else {
                showError(message: "Error: \(error.localizedDescription)")
            }
        } catch {
            showError(message: "An unexpected error occurred")
        }
        
        isLoading = false
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
        messages.append((isUser: false, text: LocalizedStringKey(message)))
    }
}

struct MessageBubble: View {
    let text: LocalizedStringKey
    let isUser: Bool
    
    var body: some View {
        HStack {
            if isUser { Spacer() }
            
            if isUser {
                Text(text)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Text(text)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            if !isUser { Spacer() }
        }
    }
}

#Preview {
    AIAssistantView()
}
