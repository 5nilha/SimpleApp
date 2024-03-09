//
//  UtilsTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import XCTest
@testable import SimpleApp

class UtilsTests: XCTestCase {

    func testWhenBundleIdentifier_thenBundleIsCorrect() {
        XCTAssertEqual(Utils.bundleIdentifier, "com.fabioQuintanilha.SimpleApp")
    }

    func testWhenAppName_thenIsCorrect() {
        XCTAssertFalse(Utils.appName.isEmpty, "App name should not be empty.")
        XCTAssertEqual(Utils.appName, "SimpleApp")
    }
    
    func testWhenAppVersion_thenVersionIsCorrect() {
        XCTAssertFalse(Utils.appVersion.isEmpty, "App version should not be empty.")
        XCTAssertEqual(Utils.appVersion, "1.0")
    }

    func testWhenAppBuildNumber_thenNumberIsCorrect() {
        XCTAssertFalse(Utils.appBuildNumber.isEmpty, "App build number should not be empty.")
        XCTAssertEqual(Utils.appBuildNumber, "1")
    }
}
