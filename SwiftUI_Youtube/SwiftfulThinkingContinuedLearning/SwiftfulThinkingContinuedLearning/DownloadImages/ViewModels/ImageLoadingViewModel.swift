//
//  ImageLoadingViewModel.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import Foundation
import SwiftUI
import Combine

class ImageLoadingViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    var cancellables = Set<AnyCancellable>()
    let cacheManager = PhotoModelCacheManager.instance
    let fmManager = PhotoModelFileManager.instance
    let urlString: String
    let imageKey: String
    
    init(urlString: String, imageKey: String) {
        self.urlString = urlString
        self.imageKey = imageKey
        getImage()
    }
    
    func getImage() {
        // manager.get(key: String)
        if let savedImage = cacheManager.get(key: imageKey) {
            image = savedImage
            print("GETTING SAVED IMAGE")
        } else {
            downloadImage()
            print("DOWNLOADING IMAGE NOW")
        }
    }
    
    func downloadImage() {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isLoading = false
            } receiveValue: { [weak self] image in
                guard let self = self, let image = image else { return }
                self.image = image
                self.cacheManager.add(key: self.imageKey, value: image)
                // self.fmManager.add(key: self.imageKey, value: image)
            }
            .store(in: &cancellables)
    }
}
