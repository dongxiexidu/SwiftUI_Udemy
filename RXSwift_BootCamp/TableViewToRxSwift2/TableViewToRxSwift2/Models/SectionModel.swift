//
//  SectionModel.swift
//  TableViewToRxSwift2
//
//  Created by Junyeong Park on 2022/08/31.
//

import Foundation
import RxDataSources

struct SectionModel {
    let header: String
    var items: [FoodModel]
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [FoodModel]) {
        self = original
        self.items = items
    }
}
