//
//  ContentView.swift
//  Touchdown_SwfitUI
//
//  Created by Junyeong Park on 2022/05/21.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
    
    func getSafeAreaTop()->CGFloat{
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return (keyWindow?.safeAreaInsets.top) ?? 0
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavigationBarView()
                    .padding(.horizontal, 15)
                    .padding(.bottom)
                    .padding(.top, getSafeAreaTop())
                // Depricated -> Check this Part
                // Norch checked
                    .background(.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 0) {
                        FeaturedTabView()
                            .frame(height: UIScreen.main.bounds.width / 1.475)
                            .padding(.vertical, 20)
                        CategoryGridVIew()
                        FooterView()
                            .padding(.horizontal)
                            
                    }
                }

//                ScrollView(.vertical, showsIndicators: false, content: {
//                    VStack(spacing: 0) {
//                        FeaturedTabView()
//                            .padding(.vertical, 20)
//                        FooterView()
//                            .padding(.horizontal)
//                    }
//                })
            }
            .background(colorBackground.ignoresSafeArea(.all, edges: .all))
        } //: ZSTACK
        .ignoresSafeArea(.all, edges: .top)
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
