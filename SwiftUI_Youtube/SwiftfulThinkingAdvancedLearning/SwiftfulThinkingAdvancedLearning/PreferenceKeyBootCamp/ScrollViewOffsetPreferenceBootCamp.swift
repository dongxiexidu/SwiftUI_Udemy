//
//  ScrollViewOffsetPreferenceBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/21.
//

import SwiftUI

struct ScrollViewOffsetPreferenceBootCamp: View {
    let title = "SCROLL VIEW"
    @State private var scrollViewOffset: CGFloat = 0
    var body: some View {
        ScrollView {
            VStack {
                titleLayer
                    .opacity(Double(scrollViewOffset) / 63.0)
                    .onScrollViewOffsetChange { offset in
                        scrollViewOffset = offset
                    }
                contentLayer
            }
            .padding()
        }
        .overlay(Text("\(scrollViewOffset)"))
        .overlay(navBarLayer.opacity(scrollViewOffset < 40 ? 1.0 : 0.0), alignment: .top)
    }
}

extension View {
    func onScrollViewOffsetChange(action:@escaping (_ offset: CGFloat) -> ()) -> some View {
        self
            .background(
                GeometryReader { geometry in
                    Text("")
                        .preference(key: ScrollViewOffsetPreferenceKey.self, value: geometry.frame(in: .global).minY)
                }
            )
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                action(value)
            }
    }
}

extension ScrollViewOffsetPreferenceBootCamp {
    private var titleLayer: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var contentLayer: some View {
        ForEach(0..<100) { _ in
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.3))
                .frame(width: 300, height: 200)
            
        }
    }
    
    private var navBarLayer: some View {
        Text("OVERLAY TITLE")
            .font(.headline)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.white)
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ScrollViewOffsetPreferenceBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewOffsetPreferenceBootCamp()
    }
}
