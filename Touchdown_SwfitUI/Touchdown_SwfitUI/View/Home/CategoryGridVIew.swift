//
//  CategoryGridVIew.swift
//  Touchdown_SwfitUI
//
//  Created by Junyeong Park on 2022/05/21.
//

import SwiftUI

struct CategoryGridVIew: View {
    // MARK: - PROPERTY
    
    // MARK: - BODY
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridLayout, alignment: .center, spacing: columnSpacing, pinnedViews: []) {
                Section(header: SectionView(rotateClockwise: false), footer: SectionView(rotateClockwise: true)){
                    ForEach(categories) { category in
                        CategoryItemView(category: category)
                    }
                }
            } //: GRID
            .frame(height: 140)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
    }
}

struct CategoryGridVIew_Previews: PreviewProvider {
    static var previews: some View {
        CategoryGridVIew()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
