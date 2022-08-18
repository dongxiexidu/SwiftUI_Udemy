//
//  MultipleSheetsBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/18.
//

import SwiftUI

struct RandomModel: Identifiable {
    let id = UUID().uuidString
    let title: String
}

// 1. use a binding
// 2. use multiple .sheets
// 3. use $item

struct MultipleSheetsBootCamp: View {
    @State private var selectedModel: RandomModel? = nil
//    @State private var showSheet: Bool = false
//    @State private var showSheet2: Bool = false
    var body: some View {
        VStack(spacing: 20) {
            
            ForEach(0..<50) { index in
                Button("Button # \(index)") {
                    selectedModel = RandomModel(title: "\(index)")
                }
            }
            
            Button("Button 1") {
                selectedModel = RandomModel(title: "ONE")
//                showSheet.toggle()
            }
//            .sheet(isPresented: $showSheet, content: {
//                NextScreen(selectedModel: RandomModel(title: "One"))
//            })
            Button("Button 2") {
                selectedModel = RandomModel(title: "TWO")
//                showSheet2.toggle()
            }
            .sheet(item: $selectedModel) { model in
                NextScreen(selectedModel: model)
            }
//            .sheet(isPresented: $showSheet2, content: {
//                NextScreen(selectedModel: RandomModel(title: "Two"))
//            })
            // 같은 하이어러키 단계에서는 여러 개의 시트를 만들 수 있다!
        }
//        .sheet(isPresented: $showSheet, content: {
//            NextScreen(selectedModel: selectedModel)
            // Closure 안의 내용은 showSheet가 true가 되는 시점에 곧바로 실행되기 때문에 Button으로 전달한 selectedModel의 값이 입력되지 않음
//            NextScreen(selectedModel: $selectedModel)
            // Binding을 통해 곧바로 값 변화를 감지!
//        })
    }
}

//struct NextScreen: View {
//    let selectedModel: RandomModel
//    var body: some View {
//        Text(selectedModel.title)
//            .font(.largeTitle)
//    }
//}

struct NextScreen: View {
//    @Binding var selectedModel: RandomModel
    // Binding으로 전달한 데이터는 다른 뷰에 의해서 달라질 위험
    let selectedModel: RandomModel
    var body: some View {
        Text(selectedModel.title)
            .font(.largeTitle)
    }
}

struct MultipleSheetsBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        MultipleSheetsBootCamp()
    }
}
