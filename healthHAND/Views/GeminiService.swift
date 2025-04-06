import Foundation
import GoogleGenerativeAI

class GeminiService {
    private let model: GenerativeModel
    
    init() {
        model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    }
    
    func generateResponse(for prompt: String) async throws -> String {
        let response = try await model.generateContent(prompt)
        guard let text = response.text else {
            throw NSError(
                domain: "GeminiService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "No response text received"]
            )
        }
        
        // Format code blocks with proper markdown syntax
        let formattedText = text.replacingOccurrences(
            of: "```([^`]+)```",
            with: "```\n$1\n```",
            options: .regularExpression
        )
        
        return formattedText
    }
} 