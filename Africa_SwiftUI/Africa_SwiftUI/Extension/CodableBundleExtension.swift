//
//  CodableBundleExtension.swift
//  Africa_SwiftUI
//
//  Created by Junyeong Park on 2022/05/17.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
            // guard를 통해 손쉽게 존재 유무 파악 가능
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
            // CoverImage 구조체가 Codable하기 때문에 decoder에서 바로 추출 가능
        }
        
        return loaded
    }
}
