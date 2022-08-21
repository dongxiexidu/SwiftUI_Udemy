//
//  AppTabBarView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/21.
//

import SwiftUI

// GENERICS
// ViewBuilder
// PreferenceKey
// MatchedGeometryEffect

struct AppTabBarView: View {
    @State private var tabSelection: TabBarItem = .home
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            Color.red
                .tabBarItem(tab: .home, selection: $tabSelection)
            Color.blue
                .tabBarItem(tab: .favorites, selection: $tabSelection)
            Color.green
                .tabBarItem(tab: .profile, selection: $tabSelection)
            Color.orange
                .tabBarItem(tab: .messages, selection: $tabSelection)
        }
    }
}

extension AppTabBarView {
    private var defaultTabView: some View {
        TabView(selection: $tabSelection) {
            Color.red
                .tabItem {
                    Image(systemName: "house")
                    Text("HOME")
                }
            
            Color.blue
                .tabItem {
                    Image(systemName: "heart")
                    Text("FAVORITES")
                }
            
            Color.orange
                .tabItem {
                    Image(systemName: "person")
                    Text("PROFILE")
                }
        }
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}
