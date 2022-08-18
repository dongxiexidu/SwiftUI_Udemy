//
//  MultipleSheetsSample.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/18.
//

import SwiftUI

struct SampleModel: Identifiable {
    let id = UUID().uuidString
    let title: String
}

struct MultipleSheetsSample: View {
    @State private var selectedModel: SampleModel? = nil
    var body: some View {
        ScrollView {
            ForEach(0..<50) { index in
                Button("Button # \(index)") {
                    selectedModel = SampleModel(title: "\(index)")
                }
                .frame(maxWidth: .infinity)
            }
        }
        .sheet(item: $selectedModel) { model in
            NextSheetSample(model: model)
        }
    }
}

struct NextSheetSample: View {
    let model: SampleModel
    var body: some View {
        Text(model.title)
    }
}

struct MultipleSheetsSample_Previews: PreviewProvider {
    static var previews: some View {
        MultipleSheetsSample()
    }
}
