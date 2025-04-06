import Foundation
import GoogleGenerativeAI

enum AIServiceError: LocalizedError {
    case noResponse
    case invalidAPIKey
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .noResponse:
            return "No response received from AI service"
        case .invalidAPIKey:
            return "Invalid API key. Please check your configuration"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

actor AIService {
    private let model: GenerativeModel
    
    init() {
        model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    }
    
    func generateResponse(for prompt: String) async throws -> String {
        do {
            let response = try await model.generateContent(prompt)
            guard let text = response.text else {
                throw AIServiceError.noResponse
            }
            
            // Format code blocks with proper markdown syntax
            let formattedText = text.replacingOccurrences(
                of: "```([^`]+)```",
                with: "```\n$1\n```",
                options: .regularExpression
            )
            
            return formattedText
        } catch let error as AIServiceError {
            throw error
        } catch {
            if error.localizedDescription.contains("API key") {
                throw AIServiceError.invalidAPIKey
            }
            throw AIServiceError.networkError(error)
        }
    }
} 