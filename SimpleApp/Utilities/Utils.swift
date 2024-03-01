//
//  Utils.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

/// `Utils` is a utility struct that provides static properties to access common application information.
struct Utils {
    
    /// `bundle` returns the main bundle of the application.
    static var bundle: Bundle? {
        return Bundle.main
    }
    
    /**
    `bundleIdentifier` returns the bundle identifier of the application as a `String`.
    If the bundle identifier cannot be found, an empty string is returned.
    */
    static var bundleIdentifier: String {
        return Utils.bundle?.bundleIdentifier ?? ""
    }
    
    /**
    `appName` returns the name of the application as specified in the app's Info.plist file.
    If the app name cannot be found, an empty string is returned.
    */
    static var appName: String {
        return Utils.bundle?.infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    /**
    `appVersion` returns the version of the application as specified in the app's Info.plist file.
     If the app version cannot be found, an empty string is returned.
    */
    static var appVersion: String {
        return Utils.bundle?.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /**
    `appBuildNumber` returns the build number of the application as specified in the app's Info.plist file.
     if the app build number cannot be found, an empty string is returned.
    */
    static var appBuildNumber: String {
        return Utils.bundle?.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
