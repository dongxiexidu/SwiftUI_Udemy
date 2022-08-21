//
//  CustomNavLink.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/21.
//

import SwiftUI

struct CustomNavLink<Label: View, Destination: View>: View {
    let destination: Destination
    let label: Label
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    var body: some View {
        NavigationLink {
            CustomNavBarContainerView {
                destination
                    .navigationBarHidden(true)
            }
        } label: {
            label
        }
    }
}

struct CustomNavLink_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavView {
            CustomNavLink(destination: Text("DESTINATION")) {
                Text("NAVIGATE")
            }
        }
    }
}
