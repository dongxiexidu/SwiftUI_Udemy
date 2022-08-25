//
//  CloudKitModel.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/25.
//

import CloudKit

protocol CloudKitableProtocol {
    init?(record: CKRecord)
    var record: CKRecord { get }
}

struct FruitModel: Identifiable, CloudKitableProtocol {
    let id = UUID().uuidString
    let name: String
    let imageURL: URL?
    let record: CKRecord
    
    init?(name: String, imageURL: URL?) {
        let record = CKRecord(recordType: "Fruits")
        record["name"] = name
        if let imageURL = imageURL {
            let asset = CKAsset(fileURL: imageURL)
            record["image"] = asset
        }
        self.init(record: record)
    }
    
    init?(record: CKRecord) {
        guard let name = record["name"] as? String else { return nil }
        self.name = name
        let imageAsset = record["image"] as? CKAsset
        let imageURL = imageAsset?.fileURL
        self.imageURL = imageURL
        self.record = record
    }
    
    func update(newName: String) -> FruitModel? {
        let record = record
        record["name"] = newName
        guard let fruit = FruitModel(record: record) else { return nil }
        return fruit
    }
}
