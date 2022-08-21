//
//  CustomNavBarContainerView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/21.
//

import SwiftUI

struct CustomNavBarContainerView<Content: View>: View {
    let content: Content
    @State private var showBackButton: Bool = true
    @State private var title: String = ""
    @State private var subtitle: String? = nil
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavBarView(showBackButton: showBackButton, title: title, subtitle: subtitle)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(CustomNavBarTitlePreferenceKey.self) { value in
            title = value
        }
        .onPreferenceChange(CustomNavBarSubtitlePreferenceKey.self) { value in
            subtitle = value
        }
        .onPreferenceChange(CustomNavBarBackButtonHiddenPreferenceKey.self) { value in
            showBackButton = !value
        }
    }
}

struct CustomNavBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBarContainerView {
            ZStack {
                Color.green.ignoresSafeArea()
                
                Text("PREVIEW CONTAINER")
                    .foregroundColor(.white)
                    .customNavigationTitle("NEW TITLE")
                    .customNavigationSubtitle("SUBTITLE")
                    .customNavigationBarBackButtonHidden(false)
            }
        }
    }
}
