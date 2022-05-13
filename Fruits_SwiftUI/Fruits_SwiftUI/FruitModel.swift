//
//  FruitModel.swift
//  Fruits_SwiftUI
//
//  Created by Junyeong Park on 2022/05/13.
//

import SwiftUI

// MARK: - FRUITS DATA MODEL

struct Fruit: Identifiable {
    var id = UUID()
    var title: String
    var headline: String
    var image: String
    var gradientColors: [Color]
    var description: String
    var nutrition: [String]
    
}
