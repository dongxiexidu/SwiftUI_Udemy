//
//  AnimalModel.swift
//  Africa_SwiftUI
//
//  Created by Junyeong Park on 2022/05/18.
//

import SwiftUI

struct Animal: Identifiable, Codable {
    let id: String
    let name: String
    let headline: String
    let description: String
    let link: String
    let image: String
    let gallery: [String]
    let fact: [String]
}
