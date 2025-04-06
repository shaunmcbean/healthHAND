import Foundation

enum Configuration {
    static var geminiAPIKey: String {
        // First try environment variable
        if let envKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] {
            return envKey
        }
        
        // Then try Info.plist
        guard let key = Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String,
              !key.isEmpty else {
            print("Warning: Gemini API key not found. Please set GEMINI_API_KEY in Config.xcconfig or environment")
            return "YOUR_API_KEY_HERE"
        }
        
        return key
    }
} 