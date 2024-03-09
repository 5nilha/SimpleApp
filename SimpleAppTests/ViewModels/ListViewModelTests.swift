//
//  ListViewModelTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/8/24.
//

import XCTest
@testable import SimpleApp

class ListViewModelTests: XCTestCase {
    
    var sut: ListViewModel! // System Under Test
    var mockAPIService: MockAPIService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAPIService = MockAPIService()
        sut = ListViewModel(requestManager: mockAPIService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockAPIService = nil
        try super.tearDownWithError()
    }
    
    func testWhenOnLoadData_thenSuccessUpdatesList() {
        let expectation = self.expectation(description: "Success loadData")
        mockAPIService.result = .success([ImageDetail(id: "1", tags: ["cute"])])
        
        sut.onLoadData = { [weak self] result in
            guard let wself = self else { return }
            switch result {
            case .success(let list):
                XCTAssertEqual(list.count, 1)
                XCTAssertEqual(wself.sut.numOfItems, 1)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Data should exist. \(error.localizedDescription)")
            }
        }
        
        sut.loadData(for: "cute")
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWhenOnLoadData_thenFailureDecodingError() {
        let expectation = self.expectation(description: "Failure loadData")
        
        let error = NSError(domain: "Failed to load data", code: 999)
        mockAPIService.result = .failure(.decodingError(error))
        
        sut.onLoadData = { result in
            switch result {
            case .success(_):
                XCTFail("Data should not exist and throw an error")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, RequestError.decodingError(error).localizedDescription)
                expectation.fulfill()
            }
        }
        
        sut.loadData()
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func testTestOnLoadData_thenFailureNetwrokError() {
        let expectation = self.expectation(description: "Failure loadData")
        
        let error = NSError(domain: "Failed to load data", code: 500)
        mockAPIService.result = .failure(.networkError(error))
        
        sut.onLoadData = { result in
            switch result {
            case .success(_):
                XCTFail("Data should not exist and throw an error")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, RequestError.networkError(error).localizedDescription)
                expectation.fulfill()
            }
        }
        
        sut.loadData()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWhenSearchForTag_thenFiltersList() {
        sut.list = [ImageDetailViewModel(imageDetail: ImageDetail(id: "1", tags: ["cute"])),
                    ImageDetailViewModel(imageDetail: ImageDetail(id: "2", tags: ["lazy"]))]
        
        XCTAssertEqual(sut.numOfItems, 2)
        
        let filteredList = sut.searchFor(tag: "cute")
        XCTAssertEqual(sut.numOfItems, 2)
        XCTAssertEqual(filteredList.count, 1)
        XCTAssertEqual(filteredList.first?.tags, ["CUTE"])
    }
}
