//
//  StartButtonView.swift
//  Fruits_SwiftUI
//
//  Created by Junyeong Park on 2022/05/13.
//

import SwiftUI

struct StartButtonView: View {
    // MARK: PROPERTY
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    // MARK: BODY
    var body: some View {
        Button(action: {
            isOnboarding = false
        }) {
            HStack(spacing: 8) {
                Text("START")
                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule().strokeBorder(.white, lineWidth: 1.25)
            )
        } //: BUTTON
        .tint(.white)
    }
}

    // MARK: PREVIEW
struct StartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StartButtonView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
