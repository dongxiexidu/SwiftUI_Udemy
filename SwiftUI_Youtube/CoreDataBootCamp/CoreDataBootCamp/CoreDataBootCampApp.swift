//
//  CoreDataBootCampApp.swift
//  CoreDataBootCamp
//
//  Created by Junyeong Park on 2022/08/19.
//

import SwiftUI

@main
struct CoreDataBootCampApp: App {
    let persistenceController = PersistenceController.shared
    // Singleton Class

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
