//
//  your_own_app_jlee364App.swift
//  your-own-app-jlee364
//
//  Created by Joshua on 4/3/24.
//

import SwiftUI

@main
struct your_own_app_jlee364App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomePage()
                .environmentObject(LetterBooksdAuth())
                .environmentObject(LetterBooksdReview())
                .environmentObject(LetterBooksdComment())
                .environmentObject(LetterBooksdCollection())
        }
    }
}
