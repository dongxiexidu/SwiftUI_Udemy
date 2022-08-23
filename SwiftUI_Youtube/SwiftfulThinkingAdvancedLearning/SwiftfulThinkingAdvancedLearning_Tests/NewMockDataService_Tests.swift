//
//  NewMockDataService_Tests.swift
//  SwiftfulThinkingAdvancedLearning_Tests
//
//  Created by Junyeong Park on 2022/08/23.
//

import XCTest
@testable import SwiftfulThinkingAdvancedLearning
import Combine

class NewMockDataService_Tests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
    }
    
    func test_NewMockDataService_init_doesSetValuesCorrectly() {
        // Given
        let items: [String]? = nil
        let items2: [String]? = []
        let items3: [String]? = [UUID().uuidString, UUID().uuidString]

        
        // When
        let dataService = NewMockDataService(items: items)
        let dataService2 = NewMockDataService(items: items2)
        let dataService3 = NewMockDataService(items: items3)

        
        // Then
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertTrue(dataService2.items.isEmpty)
        XCTAssertEqual(dataService3.items.count, items3?.count)
    }
    
    func test_NewMockDataService_donwloadItemsWithEscaping_doesReturnValues() {
        // Given
        let dataService = NewMockDataService(items: nil)

        // When
        var items = [String]()
        let expectation = XCTestExpectation()
        
        dataService.downloadItemsWithEscaping { returnendItems in
            items = returnendItems
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_donwloadItemsWithCombine_doesReturnValues() {
        // Given
        let dataService = NewMockDataService(items: nil)

        // When
        var items = [String]()
        let expectation = XCTestExpectation()
        
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion {
                case .failure(let error): XCTFail()
                case .finished: expectation.fulfill()
                }
            } receiveValue: { returnedItems in
                items = returnedItems
            }
            .store(in: &cancellables)

        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_donwloadItemsWithCombine_doesFail() {
        // Given
        let dataService = NewMockDataService(items: [])

        // When
        var items = [String]()
        let expectation = XCTestExpectation(description: "It Does Throw Errors!")
        let expectation2 = XCTestExpectation(description: "Errors = URLError bad Server Response!")

        
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    expectation.fulfill()
                    let urlError = error as? URLError
                    XCTAssertEqual(urlError, URLError(.badServerResponse))
                    if urlError == URLError(.badServerResponse) {
                        expectation2.fulfill()
                    }
                case .finished:
                    XCTFail()
                }
            } receiveValue: { returnedItems in
                items = returnedItems
            }
            .store(in: &cancellables)

        
        // Then
        wait(for: [expectation, expectation2], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
}
