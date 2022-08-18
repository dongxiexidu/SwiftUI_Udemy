//
//  HashableBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/18.
//

import SwiftUI

struct MyCustomModel: Hashable {
    let title: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

struct MyCustomModel2: Identifiable {
    let id = UUID().uuidString
    let title: String
}

struct HashableBootCamp: View {
    let data = [
        MyCustomModel(title: "ONE"),
        MyCustomModel(title: "TWO"),
        MyCustomModel(title: "THREE"),
        MyCustomModel(title: "FOUR"),
        MyCustomModel(title: "FIVE")
    ]
    let data2 = [
        MyCustomModel2(title: "ONE"),
        MyCustomModel2(title: "TWO"),
        MyCustomModel2(title: "THREE"),
        MyCustomModel2(title: "FOUR"),
        MyCustomModel2(title: "FIVE")
    ]
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                ForEach(data, id: \.self) { item in
                    // self -> String : Hashable itself
                    Text(item.hashValue.description)
                        .font(.headline)
                }
                ForEach(data2) { item in
                    Text(item.title)
                        .font(.headline)
                }
            }
        }
    }
}

struct HashableBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        HashableBootCamp()
    }
}
