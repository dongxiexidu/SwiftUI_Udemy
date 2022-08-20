//
//  DownloadingImagesRow.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI

struct DownloadingImagesRow: View {
    let model: PhotoModel
    var body: some View {
        HStack {
            DownloadingImageView(urlString: model.url, imageKey: "\(model.id)")
                .frame(width: 75, height: 75)
            VStack {
                Text(model.title)
                    .font(.headline)
                Text(model.url)
                    .foregroundColor(.gray)
                    .italic()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct DownloadingImagesRow_Previews: PreviewProvider {
    static let model = PhotoModel(albumId: 1, id: 1, title: "Mock Photo", url: "https://via.placeholder.com/600/92c952", thumbnailUrl: "https://via.placeholder.com/150/92c952")
    static var previews: some View {
        DownloadingImagesRow(model: model)
            .previewLayout(.sizeThatFits)
    }
}
