//
//  Touchdown_SwfitUIApp.swift
//  Touchdown_SwfitUI
//
//  Created by Junyeong Park on 2022/05/21.
//

import SwiftUI

@main
struct Touchdown_SwfitUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Shop())
            // 전역으로 Shop class를 "관찰"
        }
    }
}
