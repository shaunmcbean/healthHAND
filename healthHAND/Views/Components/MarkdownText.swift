import SwiftUI

struct MarkdownText: View {
    let text: String
    
    var body: some View {
        Text(.init(text))
            .textSelection(.enabled)
            .font(.body)
    }
}

#Preview {
    MarkdownText(text: """
    Here's a test message with **bold** and *italic* text.
    
    ```swift
    func test() {
        print("Hello, World!")
    }
    ```
    
    - List item 1
    - List item 2
    """)
    .padding()
} 