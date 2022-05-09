//
//  ContentView.swift
//  Pinch_SwiftUI
//
//  Created by Junyeong Park on 2022/05/09.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating :Bool = false
    @State private var imageScale :CGFloat = 1
    @State private var imageOffset: CGSize = .zero
//    Drag할 때 오프셋을 통해 표시
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
//                isAnimating이면 보이고, 그렇지 않으면 보이지 않는다.
                    .offset(x: imageOffset.width, y:imageOffset.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            resetImageState()
                        }
                    })
                    .gesture(
                    DragGesture()
                        .onChanged{ value in
                            withAnimation(.linear(duration: 1)) {
                                imageOffset = value.translation
                            }
                        }
                        .onEnded{ _ in
                            if imageScale <= 1{
                                resetImageState()
                            }
                        }
                    )
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
//            ZStack은 보이지 않기 때문에 다음 스택에서 보이도록
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
//                    부드럽게 1초 동안 isAnimating이 true인 동안 이미지 나타나도록 한다.
                }
            })
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
