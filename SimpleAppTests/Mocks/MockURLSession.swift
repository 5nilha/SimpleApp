//
//  MockURLSession.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/8/24.
//

import XCTest
@testable import SimpleApp


class MockURLSession: URLSession {
    var lastURL: URL?
    let mockTask = MockURLSessionDataTask()
    
    func mockTaskResponse(data: Data? = nil, urlResponse: HTTPURLResponse?, error: Error? = nil) {
        mockTask.setSessionTask(data: data, urlResponse: urlResponse, error: error)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        lastURL = url
        mockTask.completionHandler = completionHandler
        return mockTask
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        lastURL = request.url
        mockTask.completionHandler = completionHandler
        return mockTask
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private var data: Data?
    private var urlResponse: URLResponse?
    private var responseError: Error?
    private(set) var isResumeCalled = false
    private(set) var isCancelCalled = false
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    func setSessionTask(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.responseError = error
    }
        
    override func resume() {
        isResumeCalled = true
        isCancelCalled = false
        completionHandler?(data, urlResponse, responseError)
    }
        
    override func cancel() {
        isCancelCalled = true
        isResumeCalled = false
    }
}
