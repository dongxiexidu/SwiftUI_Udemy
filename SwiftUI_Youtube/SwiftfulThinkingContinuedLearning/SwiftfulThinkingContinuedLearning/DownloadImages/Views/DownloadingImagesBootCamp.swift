//
//  DownloadingImagesBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

// Background Threads
// Weak Self
// Combine
// Publisher and Subscriber
// FileManager and NSCache

import SwiftUI

struct DownloadingImagesBootCamp: View {
    @StateObject private var viewModel = DownloadingImagesViewModel()
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.dataArray) { model in
                    DownloadingImagesRow(model: model)
                }
            }
            .navigationTitle("Downloading Images")
        }
    }
}

struct DownloadingImagesBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingImagesBootCamp()
    }
}
