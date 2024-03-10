//
//  TagViewTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/9/24.
//

import XCTest
@testable import SimpleApp

class TagViewTests: XCTestCase {
    
    var tagView: TagView!
    
    override func setUp() {
        super.setUp()
        tagView = TagView()
    }
    
    override func tearDown() {
        tagView = nil
        super.tearDown()
    }
    
    func testTagViewInit() {
        XCTAssertNotNil(tagView)
        XCTAssertEqual(tagView.backgroundColor, ThemeManager.shared.currentTheme.primaryColor)
        XCTAssertEqual(tagView.textLabel.font, ThemeManager.shared.currentTheme.captionFont)
    }
    
    func testSetText() {
        let testText = "Test Tag"
        tagView.text = testText
        
        XCTAssertEqual(tagView.textLabel.text, testText, "Setting text should update textLabel's text")
        XCTAssertEqual(tagView.textLabel.accessibilityValue, testText, "Setting text should update textLabel's accessibilityValue")
        XCTAssertTrue(tagView.textLabel.accessibilityIdentifier?.contains(testText) ?? false, "accessibilityIdentifier should contain the new text")
    }
    
    func testLayoutSubviews() {
        tagView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        tagView.layoutSubviews()
        
        XCTAssertEqual(tagView.layer.cornerRadius, 25)
    }
}
