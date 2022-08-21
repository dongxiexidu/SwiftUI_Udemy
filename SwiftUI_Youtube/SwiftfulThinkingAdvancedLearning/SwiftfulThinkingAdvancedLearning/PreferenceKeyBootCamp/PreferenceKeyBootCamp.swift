//
//  PreferenceKeyBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/21.
//

import SwiftUI

struct PreferenceKeyBootCamp: View {
    @State private var navTitle: String = "HELLO WOLRD"
    var body: some View {
        NavigationView {
            VStack {
                SecondaryScreen(text: navTitle)
                    .navigationTitle(navTitle)
            }
        }
        .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
            self.navTitle = value
        }
    }
}

extension View {
    func customTitle(text: String) -> some View {
        self
            .preference(key: CustomTitlePreferenceKey.self, value: text)
    }
}

struct SecondaryScreen: View {
    let text: String
    @State private var newValue = "First NavBar"
    var body: some View {
        Text(text)
            .onAppear(perform: getDataFromDatabase)
            .customTitle(text: newValue)
    }
    
    private func getDataFromDatabase() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.newValue = "NEW VALUE FROM DATABASE"
        }
    }
}

struct CustomTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct PreferenceKeyBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceKeyBootCamp()
    }
}
