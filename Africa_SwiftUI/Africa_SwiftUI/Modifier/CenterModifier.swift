//
//  CenterModifier.swift
//  Africa_SwiftUI
//
//  Created by Junyeong Park on 2022/05/21.
//

import SwiftUI

struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        // Custom View modifier
        HStack {
            Spacer()
            content
            Spacer()
            // Horizontal Stack -> inside this, any contents are aligned
        }
    }
}
