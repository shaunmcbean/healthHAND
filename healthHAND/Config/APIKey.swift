import Foundation
import GoogleGenerativeAI

enum APIKey {
  // Fetch the API key from `GenerativeAI-Info.plist`
  static var `default`: String {
    // First try to load from environment variable
    if let envKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] {
      return envKey
    }
    
    // Then try to load from plist
    guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist") else {
      print("Warning: Couldn't find GenerativeAI-Info.plist. Please ensure it exists in the project and is included in the target.")
      return "YOUR_API_KEY_HERE"
    }
    
    guard let plist = NSDictionary(contentsOfFile: filePath),
          let value = plist.object(forKey: "API_KEY") as? String else {
      print("Warning: Couldn't find API_KEY in GenerativeAI-Info.plist")
      return "YOUR_API_KEY_HERE"
    }
    
    if value == "YOUR_API_KEY_HERE" {
      print("Warning: Please replace the placeholder API key in GenerativeAI-Info.plist with your actual Gemini API key")
      print("You can get an API key from: https://ai.google.dev/tutorials/setup")
    }
    
    return value
  }
}
