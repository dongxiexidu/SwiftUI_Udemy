//
//  CreditsView.swift
//  Africa_SwiftUI
//
//  Created by Junyeong Park on 2022/05/21.
//

import SwiftUI

struct CreditsView: View {
    //Copyright
    var body: some View {
        VStack {
            Image("compass")
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
            
            Text("""
    Copyright © Park Junyeong
    All right reserved
    Better Apps 👍 Less Code
    """)
            .font(.footnote)
        .multilineTextAlignment(.center)
        }
        .padding()
        .opacity(0.4)
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
