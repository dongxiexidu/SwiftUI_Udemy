//
//  Artist.swift
//  SpotifyClone
//
//  Created by Junyeong Park on 2022/09/01.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String:String]
}
