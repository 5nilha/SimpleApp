//
//  CardViewTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/9/24.
//

import XCTest
@testable import SimpleApp

class CardViewTests: XCTestCase {
    
    var cardView: CardView!
    
    override func setUp() {
        super.setUp()
        cardView = CardView()
    }
    
    override func tearDown() {
        cardView = nil
        super.tearDown()
    }
    
    
    func testTitleProperty_isVisible() {
        let title = "Test Title"
        cardView.title = title
        XCTAssertEqual(cardView.titleLabel.text, title)
        
        // Check if the title label is visible
        XCTAssertFalse(cardView.titleLabel.isHidden)
    }
    
    func testTitleProperty_isHidden() {
        cardView.title = nil
        XCTAssertNil(cardView.titleLabel.text)
        
        // Check if the title label is visible
        XCTAssertTrue(cardView.titleLabel.isHidden)
        XCTAssertTrue(cardView.captionLabel.isHidden)
    }
    
    func testCaptionProperty() {
        let caption = "Test Caption"
        cardView.caption = caption
        
        // Check if the caption label's text is updated
        XCTAssertEqual(cardView.captionLabel.text, caption)
        
        // Check if the caption label is visible when title is set
        cardView.title = "Title" // setting title makes caption visible
        XCTAssertFalse(cardView.captionLabel.isHidden)
    }
    
    func testImageProperty() {
        let image = UIImage()
        cardView.image = image
        
        // Check if the card image view's image is updated
        XCTAssertEqual(cardView.cardImageView.image, image)
    }
    
    func testTagsProperty() {
        let tags = ["tag1", "tag2"]
        cardView.tags = tags
        
        // Check if the tag list view's tags array is updated
        XCTAssertEqual(cardView.tagListView.tags, tags)
    }
}
