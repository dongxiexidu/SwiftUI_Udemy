//
//  UITestingBootCampView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/23.
//

import SwiftUI

class UITestingBootCampViewModel: ObservableObject {
    let placeholderText: String = "Add your name..."
    @Published var textFieldText: String = ""
    @Published var currentUserIsSignedIn: Bool
    
    init(currentUserIsSignedIn: Bool) {
        self.currentUserIsSignedIn = currentUserIsSignedIn
    }
    
    func signUpButtonPressed() {
        guard !textFieldText.isEmpty else { return }
        currentUserIsSignedIn = true
    }
}

struct UITestingBootCampView: View {
    @StateObject private var viewModel: UITestingBootCampViewModel
    
    init(currentUserIsSignedIn: Bool) {
        _viewModel = StateObject(wrappedValue: UITestingBootCampViewModel(currentUserIsSignedIn: currentUserIsSignedIn))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .cyan, .indigo]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ZStack {
                if viewModel.currentUserIsSignedIn {
                    SignedInHomeView()
                }
                
                if !viewModel.currentUserIsSignedIn {
                    signUpLayer
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
            }
        }
    }
}

extension UITestingBootCampView {
    private var signUpLayer: some View {
        VStack {
            TextField(viewModel.placeholderText, text: $viewModel.textFieldText)
                .accessibilityIdentifier("SignUpTextField")
                .font(.headline)
                .padding()
                .background(.white)
                .cornerRadius(10)
            Button {
                withAnimation(.spring()) {
                    viewModel.signUpButtonPressed()
                }
            } label: {
                Text("Sign Up")
                    .accessibilityIdentifier("SignUpButton")
                    .font(.headline)
                    .withDefaultButtonFormmating(Color.pink.opacity(0.6))
                    .padding(.horizontal, 60)
            }
            .withPressableStyle(0.9)
        }
        .padding(.horizontal, 30)
    }
}

struct SignedInHomeView: View {
    @State private var showAlert: Bool = false
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Show Welcome Alert!")
                }
                .accessibilityIdentifier("ShowAlertButton")
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("WELCOME TO THE WORLD!"))
                }
                NavigationLink {
                    Text("DESTINATION")
                        .font(.headline)
                        .padding(.horizontal, 60)
                } label: {
                    Text("NAVIGATION")
                        .font(.headline)
                        .withDefaultButtonFormmating(Color.pink.opacity(0.6))
                        .padding(.horizontal, 60)
                }
                .accessibilityIdentifier("NavigationLinkToDestination")
            }
            .padding()
            .navigationTitle("WELCOME")
        }
    }
}

struct UITestingBootCampView_Previews: PreviewProvider {
    static var previews: some View {
        UITestingBootCampView(currentUserIsSignedIn: false)
    }
}
