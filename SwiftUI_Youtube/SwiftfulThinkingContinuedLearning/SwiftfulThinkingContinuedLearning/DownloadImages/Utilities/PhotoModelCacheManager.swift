//
//  PhotoModelCatchManager.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import Foundation
import SwiftUI

class PhotoModelCacheManager {
    static let instance = PhotoModelCacheManager()
    private init() {}
    var photoCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 200 // 300MB
        return cache
    }()
    
    func add(key: String, value: UIImage) {
        photoCache.setObject(value, forKey: key as NSString)
    }
    
    func get(key: String) -> UIImage? {
        guard let value = photoCache.object(forKey: key as NSString) else {
            return nil
        }
        return value
    }
}
