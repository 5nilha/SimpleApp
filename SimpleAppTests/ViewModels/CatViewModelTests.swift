//
//  CatViewModelTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/8/24.
//

import XCTest
@testable import SimpleApp

class CatViewModelTests: XCTestCase {
    
    var sut: CatViewModel! // System Under Test
    var mockAPIService: MockAPIService!
    var cat: Cat!
    
    override func setUpWithError() throws {
        super.setUp()
        cat = Cat(id: "1", tags: ["cute"])
        mockAPIService = MockAPIService()
        sut = CatViewModel(cat: cat, requestManager: mockAPIService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockAPIService = nil
        cat = nil
        super.tearDown()
    }
    
    func testCatViewModelProperties() {
        let knownImageData = Data(repeating: 0, count: 5)
        sut.imageData = knownImageData
        
        XCTAssertEqual(sut.tags, ["CUTE"], "The tags property should return the cat's tags in uppercase.")
        XCTAssertEqual(sut.imageData, knownImageData, "The imageData property should return the set data.")
        
        sut.imageData = nil
    }
    
    func testDownloadImageSuccess() {
        let imageData = Data("imageData".utf8) // Simulate image data
        mockAPIService.downloadImageResult = .success(imageData)
        
        let expectation = self.expectation(description: "Image download success")
        
        sut.onImageDownloaded = { [weak self] data in
            guard let wself = self else { return }
            XCTAssertEqual(data, imageData)
            XCTAssertEqual(wself.sut.imageData, imageData)
            expectation.fulfill()
        }
        
        sut.downloadImage()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testDownloadImageFailure() {
        mockAPIService.downloadImageResult = .failure(.networkError(NSError(domain: "", code: -1, userInfo: nil)))
        
        let expectation = self.expectation(description: "Image download failure")
        
        sut.onImageDownloadError = { [weak self] error in
            guard let wself = self else { return }
            XCTAssertEqual(error.localizedDescription, RequestError.networkError(error).localizedDescription)
            XCTAssertNil(wself.sut.imageData)
            expectation.fulfill()
        }
        
        sut.downloadImage()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
