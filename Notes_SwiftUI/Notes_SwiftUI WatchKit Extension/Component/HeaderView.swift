//
//  HeaderView.swift
//  Notes_SwiftUI WatchKit Extension
//
//  Created by Junyeong Park on 2022/06/03.
//

import SwiftUI

struct HeaderView: View {
    // MARK: - PROPERTY
    var title: String = ""
    // MARK: - BODY
    var body: some View {
        VStack {
            // TITLE
            if title != "" {
                Text(title.uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
            }
            
            // SEPARATOR
            HStack {
                Capsule()
                    .frame(height:1)
                    .foregroundColor(.accentColor)
                Image(systemName: "note.text")
                    .foregroundColor(.accentColor)
                Capsule()
                    .frame(height:1)
                    .foregroundColor(.accentColor)
            }
        } //: HSTACK
    } //: VSTACK
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HeaderView(title: "CREDITS")
            HeaderView()
        }
    }
}
