//
//  VideoListView.swift
//  Africa_SwiftUI
//
//  Created by Junyeong Park on 2022/05/17.
//

import SwiftUI

struct VideoListView: View {
    @State var videos:[Video] = Bundle.main.decode("videos.json")
    // Video 셔플 -> List에서 새로 뷰를 그려주기 위함
    let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
    var body: some View {
        NavigationView {
            List {
                ForEach(videos) { video in
                    VideoListItem(video: video)
                        .padding(.vertical, 8)
                } //: LOOP
            } //: LIST
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Videos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        videos.shuffle()
                        hapticImpact.impactOccurred()
                        // 실제 디바이스에서 햅틱 기능 확인 가능
                    }) {
                        Image(systemName: "arrow.2.squarepath")
                    }
                }
            }
        }
    }
}

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView()
    }
}
