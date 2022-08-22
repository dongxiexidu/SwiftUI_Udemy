//
//  UIViewRepresentableBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/22.
//

import SwiftUI

struct TextFieldViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 55)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

extension View {
    func withDefaultUITextFieldModifier() -> some View {
        modifier(TextFieldViewModifier())
    }
}

struct UIViewRepresentableBootCamp: View {
    @State private var text: String = ""
    @State private var placeholder: String = "TYPE HERE..."
    
    var body: some View {
        VStack {
            Text(text)
                .font(.headline)
                .fontWeight(.bold)
            HStack {
                Text("SwiftUI : ")
                TextField("TYPE HERE...", text: $text)
                    .withDefaultUITextFieldModifier()
            }
            HStack {
                Text("UIKit : ")
                UITextFieldViewRepresentable(text: $text, placeholder: placeholder, placeholderColor: .gray)
                    .updatePlaceholder(placeholder)
                    .withDefaultUITextFieldModifier()
            }
        }
    }
}

struct BasicUIViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        
        view.backgroundColor = .red
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct UITextFieldViewRepresentable: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    let placeholderColor: UIColor
    
    init(text: Binding<String>, placeholder: String = "PLACEHOLDER", placeholderColor: UIColor = .gray) {
        self._text = text
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
    func makeUIView(context: Context) -> some UIView {
        let textField = getTextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    //From SwiftUI To UIKit
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let textField = uiView as? UITextField else { return }
        textField.text = text
    }
    
    
    //From UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        // CUSTOM INSTANCE BETWEEN INTERFACES
        return Coordinator(text: $text)
        
    }
    
    func updatePlaceholder(_ text: String) -> UITextFieldViewRepresentable {
        print("UPDATE PLACEHOLDER")
        var viewRepresentable = self
        viewRepresentable.placeholder = text
        return viewRepresentable
    }
    
    private func getTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        let placeholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: placeholderColor])
        textField.attributedPlaceholder = placeholder
        return textField
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}

struct UIViewRepresentableBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        UIViewRepresentableBootCamp()
    }
}


