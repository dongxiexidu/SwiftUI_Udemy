//
//  SettingsView.swift
//  Fruits_SwiftUI
//
//  Created by Junyeong Park on 2022/05/14.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    
    // MARKL - BODY
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: - SECTION1
                    
                    GroupBox(label:
                                SettingsLabelView(labelText: "Fruits", labelImage: "info.circle")
                    ) {
                        Divider()
                            .padding(.vertical, 4)
                        HStack(alignment: .center, spacing: 10) {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(9)
                            Text("Most fruits are naturally low in fat, sodium, and calories. None have cholesterol. Fruits are sources of many essential nutrients, including potassium, dietary fiber, vitamins, and much more.")
                                .font(.footnote)
                        }
                    }
                    
                    // MARK: - SECTION2
                    
                    // MARK: - SECTION3
                    GroupBox(
                        label:
                            SettingsLabelView(labelText: "Application", labelImage: "app.iphone")
                    ) {
                        SettingsRowView(name: "Developer", content: "Junyeong")
                        SettingsRowView(name: "Designer", content: "Robert Petras")
                        SettingsRowView(name: "Compatibility", content: "iOS 14")
                        SettingsRowView(name: "Website", linkLabel: "SwfitUI MasterClass", linkDestination: "swiftuimasterclass.com")
                        SettingsRowView(name: "Twitter", linkLabel: "@Robert Petras", linkDestination: "twitter.com/robertpetras")
                        SettingsRowView(name: "SwfitUI", content: "2.0")
                        SettingsRowView(name: "Version", content: "1.1.0")
                        
                    }
                    
                } //: VSTACK
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.large)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .padding()
            } //: SCROLL
        } //: MARK: NAVIGATION
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
