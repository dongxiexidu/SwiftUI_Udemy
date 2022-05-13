//
//  Fruits_SwiftUIApp.swift
//  Fruits_SwiftUI
//
//  Created by Junyeong Park on 2022/05/09.
//

import SwiftUI

@main
struct Fruits_SwiftUIApp: App {
    // Common View
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    var body: some Scene {
        WindowGroup {
            if isOnboarding == true {
                OnboardingView()
            } else {
                ContentView()
            }
        }
    }
}
