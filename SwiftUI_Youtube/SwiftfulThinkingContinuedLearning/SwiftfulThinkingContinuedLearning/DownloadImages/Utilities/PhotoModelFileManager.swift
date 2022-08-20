//
//  PhotoModelFileManager.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import Foundation
import SwiftUI

class PhotoModelFileManager {
    static let instance = PhotoModelFileManager()
    private let folderName = "downloaded_photos"
    private init() {
        createFolderIfNeeded()
    }
    
    private func createFolderIfNeeded() {
        guard let url = getFolderPath() else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                print("CREATED FOLDER")
            } catch {
                print("ERROR CREATING FOLDER")
                print(error.localizedDescription)
            }
        }
    }
    
    private func getFolderPath() -> URL? {
        return FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    // .../downloaded_photos/
    // .../downloaded_photos/[image_name].png
    private func getImagePath(key: String) -> URL? {
        guard let folder = getFolderPath() else { return nil }
        return folder.appendingPathComponent(key + ".png")
    }
    
    func add(key: String, value: UIImage) {
        guard let data = value.pngData(), let url = getImagePath(key: key) else { return }
        do {
            try data.write(to: url)
        } catch {
            print("ERROR SAVING FM")
            print(error.localizedDescription)
        }
    }
    
    func get(key: String) -> UIImage? {
        guard let url = getImagePath(key: key),
                FileManager.default.fileExists(atPath: url.path)
        else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
}
