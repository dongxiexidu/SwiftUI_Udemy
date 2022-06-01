//
//  ListRowitemView.swift
//  Devote_SwiftUI
//
//  Created by Junyeong Park on 2022/06/01.
//

import SwiftUI

struct ListRowitemView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var item: Item
    
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? .pink : .primary)
                .padding(.vertical, 12)
                .animation(.default, value: item)
            // animaion depreciated -> how to use value as constant
        } //: TOGGLE
        .toggleStyle(CheckBoxStyle())
        .onReceive(item.objectWillChange, perform: { _ in
            try? self.viewContext.save()
            // if changed, then save at any moment!
        })
    }
}
