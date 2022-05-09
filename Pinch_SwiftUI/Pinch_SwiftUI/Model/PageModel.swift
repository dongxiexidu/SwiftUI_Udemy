//
//  PageModel.swift
//  Pinch_SwiftUI
//
//  Created by Junyeong Park on 2022/05/09.
//

import Foundation

struct Page: Identifiable {
//    각 이미지를 구별하도록 "식별 가능"한 프로토콜을 준수한다는 뜻
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
