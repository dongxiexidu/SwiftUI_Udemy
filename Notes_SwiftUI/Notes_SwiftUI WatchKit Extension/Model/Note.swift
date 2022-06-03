//
//  Note.swift
//  Notes_SwiftUI WatchKit Extension
//
//  Created by Junyeong Park on 2022/06/03.
//

import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    let text: String
}
