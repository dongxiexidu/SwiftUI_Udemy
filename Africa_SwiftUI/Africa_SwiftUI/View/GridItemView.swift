//
//  GridItemView.swift
//  Africa_SwiftUI
//
//  Created by Junyeong Park on 2022/05/20.
//

import SwiftUI

struct GridItemView: View {
    let animal: Animal
    var body: some View {
        Image(animal.image)
            .resizable()
            .scaledToFit()
            .cornerRadius(12)
    }
}

struct GridItemView_Previews: PreviewProvider {
    static let animals: [Animal] = Bundle.main.decode("animals.json")
    static var previews: some View {
        GridItemView(animal: animals[0])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
