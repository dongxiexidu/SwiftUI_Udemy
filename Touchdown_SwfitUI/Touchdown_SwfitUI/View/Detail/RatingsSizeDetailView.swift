//
//  RatingsSizeDetailView.swift
//  Touchdown_SwfitUI
//
//  Created by Junyeong Park on 2022/05/21.
//

import SwiftUI

struct RatingsSizeDetailView: View {
    let sizes: [String] = ["XS", "S", "M", "L", "XL"]
    var body: some View {
        // MARK: - BODY
        HStack(alignment: .top, spacing: 3) {
            // RATINGS
            
            VStack(alignment: .leading, spacing: 3) {
                Text("Ratings")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(colorGray)
                
                HStack(alignment: .center, spacing: 3) {
                    ForEach(1...5, id:\.self) {
                        iten in
                        Button(action: {}, label: {
                            Image(systemName: "star.fill")
                                .frame(width: 28, height: 28, alignment: .center)
                                .background(colorGray.cornerRadius(5))
                                .foregroundColor(.white)
                        })
                    }
                }
            }
            
            Spacer()
            // SIZES
            VStack(alignment: .trailing, spacing: 3) {
                Text("Sizes")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(colorGray)
                HStack(alignment: .center, spacing: 5) {
                    ForEach(sizes, id: \.self) {size in
                        Button(action: {}, label: {
                            Text(size)
                                .font(.footnote)
                                .fontWeight(.heavy)
                                .foregroundColor(colorGray)
                                .frame(width: 28, height: 28, alignment: .center)
                                .background(Color.white.cornerRadius(5))
                                .background(RoundedRectangle(cornerRadius: 5).stroke(colorGray, lineWidth: 2))
                        })
                    }
                }
            }
        } //: HSTACK
    }
}

struct RatingsSizeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RatingsSizeDetailView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}