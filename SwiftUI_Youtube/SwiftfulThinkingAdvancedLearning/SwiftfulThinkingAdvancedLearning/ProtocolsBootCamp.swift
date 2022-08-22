//
//  ProtocolsBootCamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Junyeong Park on 2022/08/22.
//

import SwiftUI

protocol ColorThemeProtocol {
    // REQUIREMENTS
    var primary: Color { get }
    var secondary: Color { get }
    var tertiary: Color { get }
}

struct DefaultColorTheme: ColorThemeProtocol {
    let primary: Color = .white
    let secondary: Color = .blue
    let tertiary: Color = .gray
}

struct AlternativeColorTheme: ColorThemeProtocol {
    let primary: Color = .black
    
    let secondary: Color = .orange
    
    let tertiary: Color = .brown
    
}

protocol ButtonTextProtocol {
    var buttonText: String { get }
}

extension ButtonTextProtocol {
    func buttonPreesed2() {
        print("IT IS EXTENDED VERSION!")
    }
}

protocol ButtonPressedProtocol {
    func buttonPressed()
}

protocol ButtonDataSourceProtocol: ButtonTextProtocol, ButtonPressedProtocol {
}

class DefaultDataSource: ButtonDataSourceProtocol {
    var buttonText: String = "PROTOCOLS ARE AWESOME!"
    
    func buttonPressed() {
        print("BUTTON WAS PRESSED!")
    }
}

class AlternativeDataSource: ButtonDataSourceProtocol {
    var buttonText: String = "PROTOCOLS ARE LAME!"
    
    func buttonPressed() {
        print("BUTTON IS PRESSED VIA ALTERNATIVE ONE!")
    }
}

struct ProtocolsBootCamp: View {
    @State var colorTheme: ColorThemeProtocol
    @State var datasource: ButtonDataSourceProtocol
    var body: some View {
        ZStack {
            colorTheme.tertiary.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text(datasource.buttonText)
                    .font(.headline)
                    .foregroundColor(colorTheme.secondary)
                    .padding()
                    .background(colorTheme.primary)
                    .cornerRadius(10)
                    .onTapGesture {
                        datasource.buttonPressed()
                        datasource.buttonPreesed2()
                    }
                Spacer()
                if datasource is DefaultDataSource {
                    Text("CURENT COLORTHEME IS DEFAULT")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .background()
                        .cornerRadius(10)
                    Text("CURENT DATASOURCE IS DEFAULT")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .background()
                        .cornerRadius(10)
                } else {
                    Text("CURENT COLORTHEME IS ALTERNATIVE")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .background()
                        .cornerRadius(10)
                    Text("CURRENT DATASOURCE IS ALTERNATIVE")
                        .font(.headline)
                        .foregroundColor(.pink)
                        .padding()
                        .background()
                        .cornerRadius(10)
                }
                Button {
                    if colorTheme is DefaultColorTheme {
                        colorTheme = AlternativeColorTheme()
                    } else {
                        colorTheme = DefaultColorTheme()
                    }
                    
                    if datasource is DefaultDataSource {
                        datasource = AlternativeDataSource()
                    } else {
                        datasource = DefaultDataSource()
                    }
                    datasource.buttonPressed()
                    datasource.buttonPreesed2()
                } label: {
                    Text("Change Button DataSource and Color theme!")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .withDefaultButtonFormmating(.blue)
                        .padding(.horizontal, 10)
                }
                .withPressableStyle(0.9)
                Spacer()
            }
        }
    }
}

struct ProtocolsBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        ProtocolsBootCamp(colorTheme: DefaultColorTheme(), datasource: DefaultDataSource())
    }
}
