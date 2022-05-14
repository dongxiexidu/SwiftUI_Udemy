//
//  ContentView.swift
//  Fruits_SwiftUI
//
//  Created by Junyeong Park on 2022/05/09.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
    @State private var isShowingSettings: Bool = false
    var fruits: [Fruit] = fruitsData
    
    var body: some View {
        NavigationView{
            List {
                ForEach(fruits.shuffled()) { fruit in
                    NavigationLink(destination: FruitDetailView(fruit: fruit)) {
                        FruitRowView(fruit: fruit)
                            .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Fruits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingSettings = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                    } //: BUTTON for settings
                    .sheet(isPresented: $isShowingSettings) {
                        SettingsView()
                    }
                }
            }
        } //: NAV
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(fruits: fruitsData)
    }
}
