//
//  LongPressGestureBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/17.
//

import SwiftUI

struct LongPressGestureBootCamp: View {
    @State private var isCompleted: Bool = false
    @State private var isSuccess: Bool = false
    var body: some View {
        VStack {
            Rectangle()
                .fill(.blue)
                .frame(maxWidth: isCompleted ? .infinity : 0)
                .frame(height: 55)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.gray)
            HStack {
                Text("Click Here")
                    .foregroundColor(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(10)
                    .onLongPressGesture(minimumDuration: 1.0, maximumDistance: 50) { isPressing in
                        // press start -> min duration
                        if isPressing {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                isCompleted.toggle()
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                if !isSuccess {
                                    withAnimation(.easeInOut) {
                                        isCompleted = false
                                    }
                                }
                            }
                        }
                    } perform: {
                        withAnimation(.easeInOut) {
                            isSuccess = true
                        }
                    }
                Text("Reset")
                    .foregroundColor(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(10)
                    .onTapGesture {
                        isCompleted = false
                        isSuccess = false
                    }
            }
        }
        
//        Text(isCompleted ? "Completed" : "Uncompleted")
//            .padding()
//            .padding(.horizontal)
//            .background(isCompleted ? .green : .gray)
//            .cornerRadius(10)
//            .onTapGesture {
//                isCompleted.toggle()
//            }
        // 탭 제스처: 곧바로 반응 -> 터치의 종류에 따라 반응하도록 설계하기!
//            .onLongPressGesture(minimumDuration: 1.0, maximumDistance: 500) {
//                isCompleted.toggle()
//            }
        // 탭하는 최소 시간, 탭을 한 뒤 이동해도 버튼이 감지
    }
}

struct LongPressGestureBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        LongPressGestureBootCamp()
    }
}
