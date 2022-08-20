//
//  PhotoModel.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import Foundation

struct PhotoModel: Identifiable, Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
