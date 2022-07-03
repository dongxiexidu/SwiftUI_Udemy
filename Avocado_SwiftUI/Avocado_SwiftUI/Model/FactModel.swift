//
//  FactModel.swift
//  Avocado_SwiftUI
//
//  Created by Junyeong Park on 2022/07/03.
//

import SwiftUI

struct Fact: Identifiable {
    let id = UUID()
    let image: String
    let content: String
}

