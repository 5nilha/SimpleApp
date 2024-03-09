//
//  RequestErrorTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/8/24.
//

import XCTest
@testable import SimpleApp

class RequestErrorTests: XCTestCase {
    
    func testLogMessageForInvalidData() {
        let error = RequestError.invalidData(nil)
        XCTAssertEqual(error.logMessage, "Data received from the server was invalid, corrupted or not matching with pre-set models.\nData: nil")
    }
    
    func testLogMessageForInvalidURL() {
        let url = "http://invalid.url"
        let error = RequestError.invalidURL(url)
        XCTAssertEqual(error.logMessage, "The URL provided for the network request is invalid.\nURL: \(url)")
    }
    
    func testUserMessageForDownloadImageError() {
        let error = RequestError.downloadImageError(NSError(domain: "", code: 0, userInfo: nil))
        XCTAssertEqual(error.userMessage, "Unable to load image")
    }
    
    func testUserMessageForOtherErrors() {
        let error = RequestError.invalidData(nil)
        XCTAssertEqual(error.userMessage, "Unable to load data")
    }

    func testEqualityForInvalidData() {
        let data1: Data? = "data".data(using: .utf8)
        let data2: Data? = "data".data(using: .utf8)
        XCTAssertTrue(RequestError.invalidData(data1) == RequestError.invalidData(data2))
    }
    
    func testEqualityForDifferentErrors() {
        let error1 = RequestError.invalidURL("http://invalid.url")
        let error2 = RequestError.serverError(statusCode: 404)
        XCTAssertFalse(error1 == error2)
    }
}
