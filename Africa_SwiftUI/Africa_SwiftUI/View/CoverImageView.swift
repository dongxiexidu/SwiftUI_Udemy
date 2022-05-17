//
//  CoverImageView.swift
//  Africa_SwiftUI
//
//  Created by Junyeong Park on 2022/05/17.
//

import SwiftUI

struct CoverImageView: View {
    var coverImages: [CoverImage] = Bundle.main.decode("covers.json")
    var body: some View {
        TabView {
            ForEach(coverImages) {
                item in
                Image(item.name)
                    .resizable()
                    .scaledToFit()
            }
        }
        .tabViewStyle(.page)
        // resizable() + scaledToFit() 주로 사용하기
    }
}

struct CoverImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoverImageView()
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
