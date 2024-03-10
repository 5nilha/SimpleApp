//
//  TagsListViewTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/9/24.
//

import XCTest
@testable import SimpleApp

class TagsListViewTests: XCTestCase {
    
    var tagsListView: TagsListView!
    
    override func setUp() {
        super.setUp()
        tagsListView = TagsListView()
    }
    
    override func tearDown() {
        tagsListView.removeFromSuperview()
        tagsListView = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(tagsListView.collectionView)
        XCTAssertEqual(tagsListView.backgroundColor, .white)
      
        XCTAssertTrue(tagsListView.subviews.contains(tagsListView.collectionView))
        XCTAssertEqual(tagsListView.collectionView.delegate as? TagsListView, tagsListView)
        XCTAssertEqual(tagsListView.collectionView.dataSource as? TagsListView, tagsListView)
    }
    
    func testCollectionViewSection() {
        XCTAssertEqual(tagsListView.collectionView.numberOfSections, 1)
    }
    
    func testTagsProperty() {
        XCTAssertEqual(tagsListView.collectionView.numberOfItems(inSection: 0), 0)
        
        tagsListView.tags = ["Tag1", "Tag2", "Tag3"]
        XCTAssertEqual(tagsListView.collectionView.numberOfItems(inSection: 0), 3)
    }
    
    func testCellConfiguration() {
        tagsListView.tags = ["Test Tag"]
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = tagsListView.collectionView(tagsListView.collectionView, cellForItemAt: indexPath) as? TagCell
        XCTAssertNotNil(cell)
    }
}
