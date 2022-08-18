//
//  RotationGestureBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/18.
//

import SwiftUI

struct RotationGestureBootCamp: View {
    @State private var currentAngle: Angle = Angle(degrees: 0)
    var body: some View {
        Text("Hello, World!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(50)
            .background(Color.blue.cornerRadius(10))
            .rotationEffect(currentAngle)
            .gesture(
                RotationGesture()
                    .onChanged({ value in
                        currentAngle = value
                    })
                    .onEnded({ value in
                        currentAngle = Angle(degrees: 0)
                    })
            )
    }
}

struct RotationGestureBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        RotationGestureBootCamp()
    }
}
