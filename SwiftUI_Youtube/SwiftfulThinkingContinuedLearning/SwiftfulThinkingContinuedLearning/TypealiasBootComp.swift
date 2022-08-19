//
//  TypealiasBootComp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/19.
//

import SwiftUI

struct MovieModel {
    let title: String
    let director: String
    let count: Int
}

typealias TVModel = MovieModel

struct TypealiasBootComp: View {
    @State private var item = TVModel(title: "Dark Knight", director: "Christoper Nolan", count: 5)
    // Differenc Types -> Write Data Redundantly!
    var body: some View {
        VStack {
            Text(item.title)
            Text(item.director)
            Text("\(item.count)")
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                item = MovieModel(title: "Batman Begins", director: "Christoper Nolan", count: 5)
            }
        }
    }
}

struct TypealiasBootComp_Previews: PreviewProvider {
    static var previews: some View {
        TypealiasBootComp()
    }
}
