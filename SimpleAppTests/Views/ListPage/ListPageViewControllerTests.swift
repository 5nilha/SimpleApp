//
//  ListPageViewControllerTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/8/24.
//

import XCTest
@testable import SimpleApp

class ListPageViewControllerTests: XCTestCase {

    var sut: ListPageViewController! // sut: System Under Test
    var viewModel: ListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ListViewModel(requestManager: MockAPIService())
        sut = ListPageViewController()
        sut.listViewModel = viewModel
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testViewController_HasTableView() {
        XCTAssertNotNil(sut.listView)
    }
    
    func testViewController_TableViewHasDelegate() {
        XCTAssertNotNil(sut.listView.delegate)
    }
    
    func testViewController_TableViewHasDataSource() {
        XCTAssertNotNil(sut.listView.dataSource)
    }
    
    func testViewController_TableViewConformsToTableViewDelegateProtocol() {
        XCTAssertTrue(sut.conforms(to: UITableViewDelegate.self))
    }
    
    func testViewController_TableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(sut.conforms(to: UITableViewDataSource.self))
    }
    
    func testViewController_HasSearchBar() {
        XCTAssertNotNil(sut.searchController)
        XCTAssertEqual(sut.searchController.searchBar.placeholder, "Search for Tags")
        XCTAssertNotNil(sut.navigationItem.searchController)
        XCTAssertFalse(sut.navigationItem.hidesSearchBarWhenScrolling)
    }
    
    func testViewController_SearchBarHasUpdater() {
        XCTAssertNotNil(sut.searchController.searchResultsUpdater)
    }
    
    func testViewController_SearchBarHasAccessibility() {
        XCTAssertNotNil(sut.searchController)
        XCTAssertNotNil(sut.searchController.searchBar.accessibilityValue)
        XCTAssertNotNil(sut.searchController.searchBar.accessibilityIdentifier)
        XCTAssertEqual(sut.searchController.searchBar.accessibilityTraits, .searchField)
    }
    
    func testSearchResultsUpdating_UpdatesList() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.text = "test"
        sut.updateSearchResults(for: searchController)
    }
}
