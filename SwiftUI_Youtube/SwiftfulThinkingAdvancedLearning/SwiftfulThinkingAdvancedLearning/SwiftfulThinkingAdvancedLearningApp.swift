//
//  SwiftfulThinkingAdvancedLearningApp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI

@main
struct SwiftfulThinkingAdvancedLearningApp: App {
    let currentUserIsSignedIn: Bool
    init() {
        // First Initializer when app launched
         let userIsSignedIn: Bool = CommandLine.arguments.contains("-UITest_startSignedIn") ? true : false
//        let userIsSignedIn: Bool = ProcessInfo.processInfo.environment["-UITest_startSignedIn2"] == "true" ? true : false
        self.currentUserIsSignedIn = userIsSignedIn
    }
    var body: some Scene {
        WindowGroup {
            CloudKitCRUDBootCamp()
        }
    }
}
