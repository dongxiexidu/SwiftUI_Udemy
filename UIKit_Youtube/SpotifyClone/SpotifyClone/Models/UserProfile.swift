//
//  UserProfile.swift
//  SpotifyClone
//
//  Created by Junyeong Park on 2022/09/01.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String:Bool]
    let external_urls: [String:String]
//    let followers: [String:Any]
    let href: String
    let id: String
    let images: [APIImage]
    let product: String
}
