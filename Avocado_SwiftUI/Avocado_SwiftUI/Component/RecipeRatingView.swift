//
//  RecipeRatingView.swift
//  Avocado_SwiftUI
//
//  Created by Junyeong Park on 2022/07/03.
//

import SwiftUI

struct RecipeRatingView: View {
    // MARK: - PROPERTIES
    
    let recipe: Recipe
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            ForEach(1...(recipe.rating), id:\.self) { _ in
                Image(systemName: "star.fill")
                    .font(.body)
                    .foregroundColor(.yellow)
            }
        }
        
    }
}

struct RecipeRatingView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRatingView(recipe: recipesData[1])
            .previewLayout(.fixed(width: 320, height: 60))
    }
}
