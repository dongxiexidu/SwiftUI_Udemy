//
//  ContentView.swift
//  LearnByDoing_SwiftUI
//
//  Created by Junyeong Park on 2022/06/04.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - CONTENT

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment:.center, spacing: 20) {
                ForEach(cardData) { card in
                    // CARDVIEW
                    CardView(card: card)
                }
            }
            .padding(20)
        }
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
