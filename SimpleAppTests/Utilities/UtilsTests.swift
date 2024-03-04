//
//  UtilsTests.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import XCTest
@testable import SimpleApp

class UtilsTests: XCTestCase {

    func testBundleIdentifier() {
        // Asserts that the bundle identifier matches the expected value.
        // This test assumes you know the bundle identifier your app should have.
        XCTAssertEqual(Utils.bundleIdentifier, "com.fabioQuintanilha.SimpleApp")
    }

    func when_testAppName_then_appNameIsCorrect() {
        XCTAssertFalse(Utils.appName.isEmpty, "App name should not be empty.")
        XCTAssertEqual(Utils.appName, "SimpleApp")
    }
    
    func when_testAppVersion_then_appVersionIsCorrect() {
        XCTAssertFalse(Utils.appVersion.isEmpty, "App version should not be empty.")
        XCTAssertEqual(Utils.appVersion, "1.0")
    }

    func when_testAppBuildNumber_then_BuildNumberIsCorrect() {
        XCTAssertFalse(Utils.appBuildNumber.isEmpty, "App build number should not be empty.")
        XCTAssertEqual(Utils.appBuildNumber, "1")
    }
}
