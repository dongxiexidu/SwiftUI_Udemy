//
//  DownloadingImageView.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI

struct DownloadingImageView: View {
    @StateObject private var loader: ImageLoadingViewModel
    
    init(urlString: String, imageKey: String) {
        _loader = StateObject(wrappedValue: ImageLoadingViewModel(urlString: urlString, imageKey: imageKey))
    }
    var body: some View {
        ZStack {
            if loader.isLoading {
                ProgressView()
            } else if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(Circle())
            }
        }
    }
}

struct DownloadingImageView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingImageView(urlString: "https://via.placeholder.com/600/92c952", imageKey: "1")
            .frame(width: 75, height: 75)
            .previewLayout(.sizeThatFits)
    }
}
