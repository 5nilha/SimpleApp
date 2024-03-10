//
//  ImageDetailViewModelTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/8/24.
//

import XCTest
@testable import SimpleApp

class ImageDetailViewModelTests: XCTestCase {
    
    var sut: ImageDetailViewModel! // System Under Test
    var mockAPIService: MockAPIService!
    var imageDetail: ImageDetail!
    
    override func setUpWithError() throws {
        super.setUp()
        imageDetail = ImageDetail(id: "1", tags: ["cute"])
        mockAPIService = MockAPIService()
        sut = ImageDetailViewModel(imageDetail: imageDetail, requestManager: mockAPIService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockAPIService = nil
        imageDetail = nil
        super.tearDown()
    }
    
    func testCatViewModelProperties() {
        let knownImageData = Data(repeating: 0, count: 5)
        sut.imageData = knownImageData
        
        XCTAssertEqual(sut.tags, ["CUTE"])
        XCTAssertEqual(sut.imageData, knownImageData)
        XCTAssertEqual(sut.caption, "Owned by")
        
        sut.imageData = nil
    }
    
    func testApiUrl() {
        XCTAssertEqual(sut.api, "https://cataas.com/cat/")
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
        
        sut.loadData()
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
        
        sut.loadData()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
