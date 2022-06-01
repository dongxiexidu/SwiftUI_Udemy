//
//  Devote_SwiftUIApp.swift
//  Devote_SwiftUI
//
//  Created by Junyeong Park on 2022/05/22.
//

import SwiftUI

@main
struct Devote_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
            // managed Object Contect in the Enviornment
        }
    }
}
