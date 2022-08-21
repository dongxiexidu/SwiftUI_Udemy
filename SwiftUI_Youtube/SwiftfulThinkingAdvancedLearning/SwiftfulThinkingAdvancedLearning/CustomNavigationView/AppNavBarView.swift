//
//  AppNavBarView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/21.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        CustomNavView {
            ZStack {
                Color.orange.ignoresSafeArea()
                
                CustomNavLink(destination: customDestinationView
                    .customNavigationTitle("SECOND TITLE")
                    .customNavigationSubtitle("SUBTITLE")
                    .customNavigationBarBackButtonHidden(false)
                ) {
                    Text("NAVIGATE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .customNavBarItems(title: "NEW TITLE", subtitle: "SUBTITLE", hidden: true)
        }
    }
}

extension AppNavBarView {
    private var customDestinationView: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            Text("DESTINATION VIEW")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
    
    private var defaultNavView: some View {
        NavigationView {
            ZStack {
                Color.red.ignoresSafeArea()
                
                NavigationLink {
                    ZStack {
                        Color.green.ignoresSafeArea()
                            .navigationTitle("NAV TITLE2")
                            .navigationBarBackButtonHidden(false)
                        Text("DESTINATION VIEW")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                } label: {
                    Text("NAVIGATE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .navigationTitle("NAV TITLE")
        }
    }
}

struct AppNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppNavBarView()
    }
}

