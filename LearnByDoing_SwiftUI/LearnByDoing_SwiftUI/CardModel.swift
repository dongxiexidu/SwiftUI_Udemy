//
//  CardModel.swift
//  LearnByDoing_SwiftUI
//
//  Created by Junyeong Park on 2022/06/04.
//

import SwiftUI

// MARK: - CARD MODEL

struct Card: Identifiable {
    var id = UUID()
    var title: String
    var headline: String
    var imageName: String
    var callToAction: String
    var message: String
    var gradientColors: [Color]
}
