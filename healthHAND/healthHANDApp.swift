//
//  healthHANDApp.swift
//  healthHAND
//
//  Created by Shivank Gupta on 4/5/25.
//

import SwiftUI

@main
struct healthHANDApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
