//
//  TransitionsBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI

struct RotateViewModifier: ViewModifier {
    let angleDegree: Double
    
    init(angleDegree: Double = 40.0) {
        self.angleDegree = angleDegree
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: angleDegree))
            .offset(x: angleDegree != 0 ? UIScreen.main.bounds.width : 0,
                    y: angleDegree != 0 ? UIScreen.main.bounds.height : 0)
    }
}

extension AnyTransition {
    static var rotating: AnyTransition {
        modifier(
            active: RotateViewModifier(angleDegree: 180),
            identity: RotateViewModifier(angleDegree: 0))
    }
    
    static func rotating(angleDegree: Double) -> AnyTransition {
        modifier(
            active: RotateViewModifier(angleDegree: angleDegree),
            identity: RotateViewModifier(angleDegree: 0))
    }
    
    static var rotationOn: AnyTransition {
        asymmetric(
            insertion: .rotating,
            removal: .move(edge: .leading))
    }
}

struct TransitionsBootCamp: View {
    @State private var transitionType: Int = 0
    @State private var showRectangle: Bool = false
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button {
                    transitionType = 0
                } label: {
                    Text("First Transition")
                        .font(.headline)
                        .withDefaultButtonFormmating(.pink)
                }
                .withPressableStyle(0.8)
                Button {
                    transitionType = 1
                } label: {
                    Text("Second Transition")
                        .font(.headline)
                        .withDefaultButtonFormmating(.indigo)
                }
                .withPressableStyle(0.8)
            }
            .padding(.horizontal, 30)
            Spacer()
            if showRectangle {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 250, height: 350)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(transitionType == 0 ? .rotating(angleDegree: 1080) : .rotationOn)
            }
            Spacer()
            
            Text("Click Me")
                .withDefaultButtonFormmating()
                .padding(.horizontal, 40)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showRectangle.toggle()
                    }
                }
        }
    }
}

struct TransitionsBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        TransitionsBootCamp()
    }
}
