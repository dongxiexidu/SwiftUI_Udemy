//
//  ViewModifierBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI

struct DefaultButtonViewModifier: ViewModifier {
    let backgroundColor: Color
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 10)
    }
}

extension View {
    func withDefaultButtonFormmating(_ backgroundColor: Color = .blue) -> some View {
        // RETURN BODY
        modifier(DefaultButtonViewModifier(backgroundColor: backgroundColor))
    }
}

struct ViewModifierBootCamp: View {
    
    var body: some View {
        VStack(spacing: 10) {
            Text("HELLO WORLD")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 10)
            Text("HELLO WORLD2")
                .font(.headline)
                .modifier(DefaultButtonViewModifier(backgroundColor: .blue))
            Text("HELLO WORLD3")
                .font(.headline)
                .withDefaultButtonFormmating()
            Text("HELLO WORLD4")
                .font(.headline)
                .withDefaultButtonFormmating(.red)
        }
        .padding()
    }
}

struct ViewModifierBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        ViewModifierBootCamp()
    }
}
