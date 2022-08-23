//
//  UnitTestingBootCampViewModel.swift
//  SwiftfulThinkingAdvancedLearning_Tests
//
//  Created by Junyeong Park on 2022/08/22.
//

import XCTest
import Combine
@testable import SwiftfulThinkingAdvancedLearning

// Naming Structures: test_UnitofWork_StateUnderTest_ExpectedBehavior
// Naming Structures: test_[struct or class]_[variable or function]_[expected result]

// Testing Structure: Given, When, Then

class UnitTestingBootCampViewModel_Tests: XCTestCase {
    
    var viewModel: UnitTestingBootCampViewModel?
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func test_UnitTestingBootCampViewModel_isPremium_shouldBeTrue() {
        // Given
        let userIsPremium: Bool = true
        // When
        let viewModel = UnitTestingBootCampViewModel(isPremium: userIsPremium)
        // Then
        XCTAssertTrue(viewModel.isPremium)
    }
    
    func test_UnitTestingBootCampViewModel_isPremium_shouldBeFalse() {
        // Given
        let userIsPremium: Bool = false
        // When
        let viewModel = UnitTestingBootCampViewModel(isPremium: userIsPremium)
        // Then
        XCTAssertFalse(viewModel.isPremium)
    }
    
    func test_UnitTestingBootCampViewModel_isPremium_shouldBeInjectedValue() {
        // Given
        let userIsPremium: Bool = Bool.random()
        // When
        let viewModel = UnitTestingBootCampViewModel(isPremium: userIsPremium)
        // Then
        XCTAssertEqual(userIsPremium, viewModel.isPremium)
    }
    
    func test_UnitTestingBootCampViewModel_isPremium_shouldBeInjectedValue_stress() {
        for _ in 0..<100_000 {
            // Given
            let userIsPremium: Bool = Bool.random()
            // When
            let viewModel = UnitTestingBootCampViewModel(isPremium: userIsPremium)
            // Then
            XCTAssertEqual(userIsPremium, viewModel.isPremium)
        }
    }
    
    func test_UnitTestingBootCampViewModel_dataArray_shouldBeEmpty() {
        // Given
        
        // When
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        // Then
        XCTAssertTrue(viewModel.dataArray.isEmpty)
        XCTAssertEqual(viewModel.dataArray.count, 0)
    }
    
    func test_UnitTestingBootCampViewModel_dataArray_shouldAddItem() {
        // Given
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        // When
        viewModel.addItem(item: UUID().uuidString)
        // Then
        XCTAssertTrue(!viewModel.dataArray.isEmpty)
        XCTAssertFalse(viewModel.dataArray.isEmpty)
        XCTAssertEqual(viewModel.dataArray.count, 1)
        XCTAssertNotEqual(viewModel.dataArray.count, 0)
        XCTAssertGreaterThan(viewModel.dataArray.count, 0)
        XCTAssertGreaterThanOrEqual(viewModel.dataArray.count, 0)
    }
    
    func test_UnitTestingBootCampViewModel_dataArray_shouldAddItems() {
        // Given
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        // When
        let loopCount: Int = Int.random(in: 1..<10)
        for _ in 0..<loopCount {
            viewModel.addItem(item: UUID().uuidString)
        }
        // Then
        XCTAssertTrue(!viewModel.dataArray.isEmpty)
        XCTAssertFalse(viewModel.dataArray.isEmpty)
        XCTAssertEqual(viewModel.dataArray.count, loopCount)
        XCTAssertNotEqual(viewModel.dataArray.count, 0)
        XCTAssertGreaterThan(viewModel.dataArray.count, 0)
        XCTAssertGreaterThanOrEqual(viewModel.dataArray.count, 0)
    }
    
    func test_UnitTestingBootCampViewModel_dataArray_shouldNotAddBlankString() {
        // Given
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        // When
        viewModel.addItem(item: "")
        // Then
        XCTAssertTrue(viewModel.dataArray.isEmpty)
    }
    
    func test_UnitTestingBootCampViewModel_dataArray_shouldNotAddBlankString2() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
            
        }
        // When
        viewModel.addItem(item: "")
        // Then
        XCTAssertTrue(viewModel.dataArray.isEmpty)
    }
    
    func test_UnitTestingBootCampViewModel_selectedItem_shouldStartAsNil() {
        // Given

        // When
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        // Then
        XCTAssertTrue(viewModel.selectedItem == nil)
        XCTAssertNil(viewModel.selectedItem)
    }
    
    func test_UnitTestingBootCampViewModel_selectedItem_shouldBeNilWhenSelectionInvalidItem() {
        // Given
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        
        // When
        // select valid item
        let newItem = UUID().uuidString
        viewModel.addItem(item: newItem)
        viewModel.selectItem(item: newItem)
        
        // select invalid item
        viewModel.selectItem(item: UUID().uuidString)
        // Then
        XCTAssertTrue(viewModel.selectedItem == nil)
        XCTAssertNil(viewModel.selectedItem)
    }
    
    func test_UnitTestingBootCampViewModel_selectedItem_shouldBeSelected() {
        // Given
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        
        // When
        let newItem = UUID().uuidString
        viewModel.addItem(item: newItem)
        viewModel.selectItem(item: newItem)
        // Then
        XCTAssertNotNil(viewModel.selectedItem)
        XCTAssertEqual(viewModel.selectedItem, newItem)
    }
    
    func test_UnitTestingBootCampViewModel_selectedItem_shouldBeSelected_stress() {
        // Given
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        var itemArray = [String]()
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            viewModel.addItem(item: newItem)
            itemArray.append(newItem)
            viewModel.selectItem(item: newItem)
        }
        
        let randomItem = itemArray.randomElement() ?? ""
        viewModel.selectItem(item: randomItem)
        
        // Then
        XCTAssertNotNil(viewModel.selectedItem)
        XCTAssertEqual(viewModel.selectedItem, randomItem)
    }
    
    func test_UnitTestingBootCampViewModel_saveItem_shouldThrowError_noItemFound() {
        // Given
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            viewModel.addItem(item: UUID().uuidString)
        }
        
        // Then
        XCTAssertThrowsError(try viewModel.saveItem(item: UUID().uuidString))
        XCTAssertThrowsError(try viewModel.saveItem(item: UUID().uuidString), "Should throw Item Not Found Error!") { error in
            let returnedError = error as? UnitTestingBootCampViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestingBootCampViewModel.DataError.noItemFound)
        }
    }
    
    func test_UnitTestingBootCampViewModel_saveItem_shouldThrowError_noData() {
        // Given
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            viewModel.addItem(item: UUID().uuidString)
        }
        
        // Then
        
        do {
            try viewModel.saveItem(item: "")
        } catch let error {
            let returnedError = error as? UnitTestingBootCampViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestingBootCampViewModel.DataError.noData)
        }
    }
    
    func test_UnitTestingBootCampViewModel_saveItem_shouldSaveItem() {
        // Given
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        var itemsArray: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            viewModel.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        
        let randomItem = itemsArray.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)
        
        // Then
        XCTAssertNoThrow(try viewModel.saveItem(item: randomItem))
        
        do {
            try viewModel.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
    }
    
    func test_UnitTestingBootCampViewModel_downloadWithEscaping_shouldReturnItems() {
        // Given
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        
        // When
        let expectation = XCTestExpectation(description: "Should Return Items after 3 seconds")
        viewModel.$dataArray
            .dropFirst()
            .sink { returnedItems in
                // Extepctation Observer
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.downloadWithEscaping()

        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertGreaterThan(viewModel.dataArray.count, 0)
    }
    
    func test_UnitTestingBootCampViewModel_downloadWithCombine_shouldReturnItems() {
        // Given
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random())
        
        // When
        let expectation = XCTestExpectation(description: "Should Return Items after a seconds")
        viewModel.$dataArray
            .dropFirst()
            .sink { returnedItems in
                // Extepctation Observer
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.downloadWithCombine()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertGreaterThan(viewModel.dataArray.count, 0)
    }
    
    func test_UnitTestingBootCampViewModel_downloadWithCombine_shouldReturnItems2() {
        // Given
        let items = Array(repeating: UUID().uuidString, count: 5)
        let dataService: NewDataServiceProtocol = NewMockDataService(items: items)
        let viewModel = UnitTestingBootCampViewModel(isPremium: Bool.random(), dataService: dataService)
        
        // When
        let expectation = XCTestExpectation(description: "Should Return Items after a seconds")
        viewModel.$dataArray
            .dropFirst()
            .sink { returnedItems in
                // Extepctation Observer
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.downloadWithCombine()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertGreaterThan(viewModel.dataArray.count, 0)
        XCTAssertEqual(viewModel.dataArray.count, items.count)
    }
    
    
}
