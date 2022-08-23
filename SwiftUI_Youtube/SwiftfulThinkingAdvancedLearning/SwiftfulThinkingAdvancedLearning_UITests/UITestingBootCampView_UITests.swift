//
//  UITestingBootCampView_UITests.swift
//  SwiftfulThinkingAdvancedLearning_UITests
//
//  Created by Junyeong Park on 2022/08/23.
//

// Naming Structures: test_UnitofWork_StateUnderTest_ExpectedBehavior
// Naming Structures: test_[struct]_[ui component]_[expected result]

// Testing Structure: Given, When, Then

import XCTest
import SwiftUI

class UITestingBootCampView_UITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
//        app.launchArguments = ["-UITest_startSignedIn"]
        app.launch()
    }

    override func tearDownWithError() throws {
    }
    
    func test_UITestingBootCampView_singUpButton_shouldNotSignIn() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: false)
        // When
        let navBar = app.navigationBars["WELCOME"]
                
        // Then
        XCTAssertFalse(navBar.exists)
    }
    
    func test_UITestingBootCampView_singUpButton_shouldSignIn() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        // When
        let navBar = app.navigationBars["WELCOME"]
                
        // Then
        XCTAssertTrue(navBar.exists)
    }
    
    func test_SignedInHomeView_showAlertButton_shouldDisplayAlert() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        // When
        tapAlertButton(shouldDismissButton: false)
        let alert = app.alerts.firstMatch
        // Then
        XCTAssertTrue(alert.exists)
    }
    
    func test_SignedInHomeView_showAlertButton_shouldDismissAlert() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        // When
        tapAlertButton(shouldDismissButton: true)
        // Then
        let alert = app.alerts.firstMatch
        XCTAssertFalse(alert.exists)
    }
    
    func test_SignedInHomeView_NavigationLinkToDestination_shouldNavigateToDestination() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        // When
        tapNaivgationLink(shouldDismissDestination: false)
        // Then
        let destinationText = app.staticTexts["DESTINATION"]
        XCTAssertTrue(destinationText.exists)
    }
    
    func test_SignedInHomeView_NavigationLinkToDestination_shouldNavigateToDestinationAndGoBack() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        // When
        tapNaivgationLink(shouldDismissDestination: true)
        let navBar = app.navigationBars["WELCOME"]
        // Then
        XCTAssertTrue(navBar.exists)
    }
    
//    func test_SignedInHomeView_NavigationLinkToDestination_shouldNavigateToDestinationAndGoBack2() {
//        // Given
//
//        // When
//        tapNaivgationLink(shouldDismissDestination: true)
//        let navBar = app.navigationBars["WELCOME"]
//        // Then
//        XCTAssertTrue(navBar.exists)
//    }
}

extension UITestingBootCampView_UITests {
    func signUpAndSignIn(shouldTypeOnKeyboard: Bool) {
        let textField = app.textFields["SignUpTextField"]
        textField.tap()
        
        if shouldTypeOnKeyboard {
            textField.typeText("ID")
        }
        let signUpButton = app.buttons["SignUpButton"]
        signUpButton.tap()
    }
    
    func tapAlertButton(shouldDismissButton: Bool) {
        let showAlertButton = app.buttons["ShowAlertButton"]
        showAlertButton.tap()
        if shouldDismissButton {
            let alert = app.alerts.firstMatch
            let alertOKButton = alert.scrollViews.otherElements.buttons["OK"]
            alertOKButton.tap()
        }
    }
    
    func tapNaivgationLink(shouldDismissDestination: Bool) {
        let navigationLinkButton = app.buttons["NavigationLinkToDestination"]
        navigationLinkButton.tap()
        if shouldDismissDestination {
            let backButton = app.navigationBars.buttons["WELCOME"]
            backButton.tap()
        }
    }
}
