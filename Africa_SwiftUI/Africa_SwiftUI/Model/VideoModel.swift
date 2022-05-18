//
//  VideoModel.swift
//  Africa_SwiftUI
//
//  Created by Junyeong Park on 2022/05/19.
//

import SwiftUI

struct Video: Codable, Identifiable {
    let id: String
    let name: String
    let headline: String
    
    // Computed Property
    
    var thumbnail: String {
        "video-\(id)"
    }
}
