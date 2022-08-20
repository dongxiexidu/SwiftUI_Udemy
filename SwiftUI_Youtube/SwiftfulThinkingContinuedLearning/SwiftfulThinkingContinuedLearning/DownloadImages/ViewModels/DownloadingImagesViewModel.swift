//
//  DownloadingImagesViewModel.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import Foundation
import Combine

class DownloadingImagesViewModel: ObservableObject {
    @Published var dataArray = [PhotoModel]()
    private let dataService = PhotoModelDataService.instance
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubsribers()
    }
    
    private func addSubsribers() {
        dataService.$photoModels.sink { [weak self] photoModels in
            guard let self = self else { return }
            self.dataArray = photoModels
        }
        .store(in: &cancellables)
    }
}
