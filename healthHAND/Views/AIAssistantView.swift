import SwiftUI
import GoogleGenerativeAI

//
//  ContentView.swift
//  ChatWithGemini
//
//  Created by Etisha Garg on 03/05/24.
//

import SwiftUI
import GoogleGenerativeAI

struct AIAssistantView: View {
    @State private var userInput = ""
    @State private var messages: [(isUser: Bool, text: LocalizedStringKey)] = []
    @State private var isLoading = false
    private let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    var body: some View {
        NavigationStack {
            VStack {
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
                                .progressViewStyle(CircularProgressViewStyle())
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
            .navigationTitle("AI Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
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
                messages.append((isUser: false, text: "No response received from AI"))
            }
        } catch {
            messages.append((isUser: false, text: LocalizedStringKey("Error: \(error.localizedDescription)")))
        }
        
        isLoading = false
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
