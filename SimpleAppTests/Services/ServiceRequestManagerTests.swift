//
//  ServiceRequestManagerTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/8/24.
//

import XCTest
@testable import SimpleApp

class ServiceRequestManagerTests: XCTestCase {
    
    let sut: ServiceRequestManager = ServiceRequestManager.shared
    let mockSession: MockURLSession = MockURLSession()
    
    override func setUp() {
        super.setUp()
        sut.session = mockSession
    }
    
    override func tearDown() {
        sut.session = .shared
        super.tearDown()
    }
    
    func testWhenCancelAResumedTask() {
        mockSession.mockTask.resume()
        XCTAssertTrue(mockSession.mockTask.isResumeCalled)
        XCTAssertFalse(mockSession.mockTask.isCancelCalled)
        
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        sut.fetchItems(with: request, of: MockModelDecodable.self) { result in }
        sut.cancelCurrentTask()
        XCTAssertTrue(mockSession.mockTask.isCancelCalled)
    }
    
    func testResumeATask() {
        sut.resumeTask(task: mockSession.mockTask)
        XCTAssertTrue(mockSession.mockTask.isResumeCalled)
    }
    
    func testWhenFetchItems_thenResponseSuccess() {
        // Given: A mock JSON to return as successful response
        let jsonData = "{\"key\":\"value\"}".data(using: .utf8)
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.mockTaskResponse(data: jsonData, urlResponse: urlResponse, error: nil)
        
        let expectation = self.expectation(description: "FetchItemsSuccess")
        
        // When: Fetching items
        sut.fetchItems(with: request, of: MockModelDecodable.self) { result in
            if case .success(let decodedObject) = result {
                XCTAssertEqual(decodedObject.key, "value")
                expectation.fulfill()
            } else {
                XCTFail("FetchItems should have successfull data")
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testWhenFetchItems_thenResponseFailureWithError() {
        let error = NSError(domain: "TestError", code: -1, userInfo: nil)
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.mockTaskResponse(urlResponse: urlResponse, error: error)
        
        let expectation = self.expectation(description: "FetchItemsFailure")
        
        // When: Fetching items
        sut.fetchItems(with: request, of: MockModelDecodable.self) { result in
            switch result {
            case .success(_):
                XCTFail("FetchItems should throws error")
            case .failure(let requestError):
                XCTAssertEqual(requestError, .networkError(error))
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testWhenFetchItems_thenInvalidResponse() {
        let jsonData = "{\"key\":\"value\"}".data(using: .utf8)
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 300, httpVersion: nil, headerFields: nil)
        mockSession.mockTaskResponse(data: jsonData, urlResponse: urlResponse, error: nil)
        
        let expectation = self.expectation(description: "FetchItemsWithUrlResponseError")
        
        // When: Fetching items
        sut.fetchItems(with: request, of: MockModelDecodable.self) { result in
            switch result {
            case .success(_):
                XCTFail("FetchItems should throws error")
            case .failure(let requestError):
                XCTAssertEqual(requestError, .serverError(statusCode: 300))
                XCTAssertNotNil(requestError)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testWhenFetchItems_thenInvalidData() {
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.mockTaskResponse(urlResponse: urlResponse, error: nil)
        
        let expectation = self.expectation(description: "FetchItemsWithUrlResponseError")
        
        // When: Fetching items
        sut.fetchItems(with: request, of: MockModelDecodable.self) { result in
            switch result {
            case .success(_):
                XCTFail("FetchItems should throws error")
            case .failure(let requestError):
                XCTAssertEqual(requestError, .invalidData(nil))
                XCTAssertNotNil(requestError)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testWhenFetchItems_thenDataDecodeError() {
        let jsonData = "{\"key\":\"value\"}".data(using: .utf8)
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.mockTaskResponse(data: jsonData, urlResponse: urlResponse, error: nil)
        
        let expectation = self.expectation(description: "FetchItemsWithUrlResponseError")
        
        // When: Fetching items
        sut.fetchItems(with: request, of: Data.self) { result in
            switch result {
            case .success(_):
                XCTFail("FetchItems should throws error")
            case .failure(let requestError):
                XCTAssertNotNil(requestError)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
