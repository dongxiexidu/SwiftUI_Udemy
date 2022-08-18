//
//  DragGestureBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/18.
//

import SwiftUI

// DRAG GESTURE -> MAKE IT SWIPABLE USING DRAG GESTURE
struct DragGestureBootCamp: View {
    @State private var currentOffset: CGSize = .zero
    var currentScaleAmount: CGFloat {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(currentOffset.width)
        let percentage = currentAmount / max
        return 1.0 - min(percentage, 0.5) * 0.5
    }
    var currentRotationAngle: Angle {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = currentOffset.width
        let percentage = currentAmount / max
        let percentageAsDouble = Double(percentage)
        let maxAngle = 10.0
        return Angle(degrees: percentageAsDouble * maxAngle)
    }
    var body: some View {
        ZStack {
            
            VStack {
                Text("\(currentOffset.width)")
                Spacer()
            }
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 300, height: 500)
                .offset(currentOffset)
                .scaleEffect(currentScaleAmount)
                .rotationEffect(currentRotationAngle)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            withAnimation(.spring()) {
                                currentOffset = value.translation
                            }
                        })
                        .onEnded({ value in
                            withAnimation(.spring()) {
                                currentOffset = .zero
                            }
                        })
            )
        }
    }
}

struct DragGestureBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        DragGestureBootCamp()
    }
}
