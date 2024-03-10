//
//  ImageDetailTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/9/24.
//

import XCTest
@testable import SimpleApp

class ImageDetailTests: XCTestCase {
    
    func testImageDetailInitizalizing() {
        let imageDetail = ImageDetail(id: "12345", tags: ["cute", "gif"])

        XCTAssertEqual(imageDetail.id, "12345")
        XCTAssertEqual(imageDetail.tags, ["cute", "gif"])
    }

    func testImageDetailDecoding() {
        guard let data = mockDecodableData()
        else {
            XCTFail("failed to Mock Decodable Data")
            return
        }
        
         let decoder = JSONDecoder()
         do {
             
             // Assert the ImageDetail can be decoded
             let imageDetail = try decoder.decode(ImageDetail.self, from: data)
             XCTAssertNotNil(imageDetail)
             
             // Assert the decoded values are as expected
             XCTAssertEqual(imageDetail.id, "12345")
             XCTAssertEqual(imageDetail.tags, ["landscape", "nature"])
         } catch {
             XCTFail("Decoding failed with error: \(error)")
         }
     }
    
    private func mockDecodableData() -> Data? {
        // Mock JSON string that represents an ImageDetail
        let jsonString = """
        {
            "_id": "12345",
            "tags": ["landscape", "nature"]
        }
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert string to Data")
            return nil
        }
        
        return jsonData
    }
}
