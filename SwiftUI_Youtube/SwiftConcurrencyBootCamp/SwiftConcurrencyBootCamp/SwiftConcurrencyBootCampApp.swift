//
//  SwiftConcurrencyBootCampApp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Junyeong Park on 2022/08/26.
//

import SwiftUI

@main
struct SwiftConcurrencyBootCampApp: App {
    var body: some Scene {
        WindowGroup {
            TaskGroupBootCamp(dataService: TaskGroupBootCampDataService(), urlString: "https://picsum.photos/1000")
        }
    }
}
