//
//  HideKeyboardExtension.swift
//  Devote_SwiftUI
//
//  Created by Junyeong Park on 2022/05/25.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
