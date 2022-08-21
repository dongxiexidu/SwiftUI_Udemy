//
//  ViewBuilderBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/21.
//

import SwiftUI

struct HeaderViewRegular: View {
    let title: String
    let description: String?
    let iconName: String?
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            if let description = description {
                Text(description)
                    .font(.callout)
            }
            if let iconName = iconName {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct HeaderViewGeneric<Content:View>: View {
    let title: String
    let content: Content
    
    init(title: String, content: Content) {
        self.title = title
        self.content = content
    }
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            content
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct CustomHStack<Content: View>:View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content
        }
    }
}

struct ViewBuilderBootCamp: View {
    var body: some View {
        ScrollView {
            VStack {
                HeaderViewRegular(title: "NEW TITLE", description: "HELLO", iconName: "flame.fill")
                HeaderViewRegular(title: "Another TITLE", description: nil, iconName: nil)
                HeaderViewGeneric(title: "GENERIC TITLE", content: Text("CONTENT!"))
                HeaderViewGeneric(title: "GENERIC TITLE", content: Image(systemName: "flame.fill"))
                HeaderViewGeneric(title: "GENERIC TITLE", content: HStack {
                    Text("HELLO!")
                    Image(systemName: "flame.fill")
                })
                HeaderViewGeneric(title: "CONTENT CLOSURE!") {
                    HStack {
                        Text("HI!")
                        Image(systemName: "bolt.fill")
                    }
                }
                HeaderViewGeneric(title: "CUSTOM HSTACK") {
                    CustomHStack {
                        Text("HELLO!")
                        Text("THIS IS CUSTOM HSTACK!")
                    }
                }
                Spacer()
            }
        }
    }
}

struct LocalViewBuilder: View {
    enum ViewType {
        case one, two, three
    }
    @State private var type: ViewType = ViewType.one
    var body: some View {
        VStack {
            buttonView
            .padding()
            headerSection
        }
    }
    
    @ViewBuilder private var headerSection: some View {
        switch type {
        case .one:
            viewOne
        case .two:
            viewTwo
        case .three:
            viewThree
        }
    }
    
    private var buttonView: some View {
        HStack {
            Button {
                type = .one
            } label: {
                Text("TYPE ONE")
                    .withDefaultButtonFormmating()
            }
            .withPressableStyle(0.9)
            Button {
                type = .two
            } label: {
                Text("TYPE TWO")
                    .withDefaultButtonFormmating()
            }
            .withPressableStyle(0.9)
            Button {
                type = .three
            } label: {
                Text("TYPE ONE")
                    .withDefaultButtonFormmating()
            }
            .withPressableStyle(0.9)
        }
        .padding()
    }
    
    private var viewOne: some View {
        Text("ONE")
    }
    
    private var viewTwo: some View {
        VStack {
            Text("TWO")
            Image(systemName: "flame.fill")
        }
    }
    
    private var viewThree: some View {
        HStack {
            Text("THREE")
            Image(systemName: "flame.fill")
        }
    }
}

struct ViewBuilderBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        LocalViewBuilder()
    }
}
