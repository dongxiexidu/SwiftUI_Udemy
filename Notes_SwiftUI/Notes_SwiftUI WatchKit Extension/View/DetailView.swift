//
//  DetailView.swift
//  Notes_SwiftUI WatchKit Extension
//
//  Created by Junyeong Park on 2022/06/03.
//

import SwiftUI

struct DetailView: View {
    // MARK: - PROPERTY
    let note: Note
    let count: Int
    let index: Int
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            // HEADER
            HStack {
                Capsule()
                    .frame(height:1)
                    .foregroundColor(.accentColor)
                Image(systemName: "note.text")
                    .foregroundColor(.accentColor)
                Capsule()
                    .frame(height:1)
                    .foregroundColor(.accentColor)
            } //: HSTACK
            // CONTENT
            Spacer()
            
            ScrollView(.vertical) {
                Text(note.text)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            // FOOTER
            HStack(alignment: .center) {
                Image(systemName: "gear")
                    .imageScale(.large)
                Spacer()
                Text("\(count) / \(index + 1)")
                Spacer()
                Image(systemName: "info.circle")
                    .imageScale(.large)
            } //: HSTACK
            .foregroundColor(.secondary)
        } //: VSTACK
        .padding(3)
    }
}

// MARK: - PREVIEW
struct DetailView_Previews: PreviewProvider {
    static var sampleData: Note = Note(id: UUID(), text: "Hello, World!")
    static var previews: some View {
        DetailView(note: sampleData, count: 5, index: 1)
    }
}
