//
//  AddToCartDetailView.swift
//  Touchdown_SwfitUI
//
//  Created by Junyeong Park on 2022/05/21.
//

import SwiftUI

struct AddToCartDetailView: View {
    var body: some View {
        Button(action: {}, label: {
            Spacer()
            Text("Add to Cart".uppercased())
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
        }) //: BUTTON
        .padding(15)
        .background(
            Color(red:sampleProduct.red,
                  green: sampleProduct.green,
                  blue: sampleProduct.blue))
        .clipShape(Capsule())
    }
}

struct AddToCartDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AddToCartDetailView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
