//
//  UIViewControllerRepresentableBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/22.
//

import SwiftUI

struct UIViewControllerRepresentableBootCamp: View {
    @State private var showScreen: Bool = false
    @State private var image: UIImage? = nil
    var body: some View {
        VStack(spacing: 20) {
            Text(image == nil ? "SELECT YOUR IMAGE" : "SELECTED IMAGE")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.pink)
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            Button {
                showScreen.toggle()
            } label: {
                Text("CLICK HERE")
                    .withDefaultButtonFormmating(Color.blue)
                    .padding(.horizontal, 40)
            }
            .withPressableStyle(0.8)
            .sheet(isPresented: $showScreen) {
//                BasicUIViewControllerRepresentable(labelText: "HELLO WORLD!")
                UIImagePickerControllerRepresentable(image: $image, showScreen: $showScreen)
            }
        }
    }
}

struct BasicUIViewControllerRepresentable: UIViewControllerRepresentable {
    let labelText: String
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = MyFirstViewController()
        viewController.labelText = labelText
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

class MyFirstViewController: UIViewController {
    var labelText: String = "Starting Value"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    private func setView() {
        view.backgroundColor = .blue
        let label = UILabel()
        label.text = labelText
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

struct UIImagePickerControllerRepresentable: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showScreen: Bool
    func makeUIViewController(context: Context) -> some UIImagePickerController {
        let viewContoller = UIImagePickerController()
        viewContoller.allowsEditing = false
        viewContoller.delegate = context.coordinator
        return viewContoller
    }
    
    // from SwiftUI to UIKit
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    // from UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, showScreen: $showScreen)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
        @Binding var image: UIImage?
        @Binding var showScreen: Bool
        
        init(image: Binding<UIImage?>, showScreen: Binding<Bool>) {
            self._image = image
            self._showScreen = showScreen
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.image = image
            showScreen = false
        }
    }
}

struct UIViewControllerRepresentableBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerRepresentableBootCamp()
    }
}
