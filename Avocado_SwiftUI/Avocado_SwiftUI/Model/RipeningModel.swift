//
//  RipeningModel.swift
//  Avocado_SwiftUI
//
//  Created by Junyeong Park on 2022/07/03.
//

import SwiftUI

// MARK: - RIPENING MODEL
struct Ripening: Identifiable {
    let id = UUID()
    let image: String
    let stage: String
    let title: String
    let description: String
    let ripeness: String
    let instruction: String
}
