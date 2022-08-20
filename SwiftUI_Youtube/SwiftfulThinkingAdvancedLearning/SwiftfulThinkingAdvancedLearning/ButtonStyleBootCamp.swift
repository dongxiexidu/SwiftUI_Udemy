//
//  ButtonStyleBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    let scaledAmount: CGFloat
    
    init(scaledAmount: CGFloat = 0.9) {
        self.scaledAmount = scaledAmount
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
//            .brightness(configuration.isPressed ? 0.1 : 0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

extension View {
    func withPressableStyle(_ scaledAmount: CGFloat = 0.9) -> some View {
        buttonStyle(PressableButtonStyle(scaledAmount: scaledAmount))
    }
}

struct ButtonStyleBootCamp: View {
    var body: some View {
        VStack {
            Button(action: {
                
            }, label: {
                Text("CLICK ME")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0.0, y: 10)
            })
            .buttonStyle(PressableButtonStyle())
            Button(action: {
                
            }, label: {
                Text("CLICK ME")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0.0, y: 10)
            })
            .buttonStyle(PressableButtonStyle(scaledAmount: 0.7))
            Button(action: {
                
            }, label: {
                Text("CLICK ME")
                    .withDefaultButtonFormmating(.red)
            })
            .withPressableStyle(0.5)
        }
        .padding(40)
    }
}

struct ButtonStyleBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStyleBootCamp()
    }
}
