//
//  FeatureFlags.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

enum FeatureFlag: String, Codable {
    case enableLogs
    case enablePrintLogs
    case enableLogDebugging
    case enableLogInfo
    case enableLogThreads
    case enableLogError
}

/**
 `Feature flags` enable or disable functionality at runtime, allowing for flexible configuration
 and easy feature toggling without needing to redeploy or alter the application's binary.
 */
class FeatureFlags {
    
    /**
     `features` determines which features are currently enabled in the application
    */
    static private (set) var features: Set<FeatureFlag> = [
        .enableLogs,
        .enablePrintLogs,
        .enableLogInfo,
        .enableLogError,
        .enableLogThreads
    ]
    
    /**
     Activates a specific feature by adding its flag to the `features` set.
    - Parameter feature: The `FeatureFlag` to be activated.
    */
    class func activateFeature(_ feature: FeatureFlag) {
        FeatureFlags.features.insert(feature)
    }
    
    /**
     Deactivates a specific feature by removing its flag from the `features` set.
    - Parameter feature: The `FeatureFlag` to be deactivated.
    */
    class func deactivateFeature(_ feature: FeatureFlag) {
        FeatureFlags.features.remove(feature)
    }
    
    /// Removes all feature flags from the `features` set, effectively deactivating all features.
    class func removeAllFeatures() {
        FeatureFlags.features.removeAll()
    }
    
    /**
     Checks if a specific feature is enabled by looking for its flag in the `features` set.
    - Parameter feature: The `FeatureFlag` to check for activation.
    - Returns: A Boolean value indicating whether the feature is enabled (`true`) or not (`false`).
     */
    class func hasFeature(_ feature: FeatureFlag) -> Bool {
        FeatureFlags.features.contains(feature)
    }
    
    /**
     Checks if a specific feature is enabled by looking for its flag in the `features` set.
    - Parameter features: The list of `FeatureFlag` to check for activation.
    - Returns: A Boolean value indicating whether the feature is enabled (`true`) or not (`false`).
     */
    class func hasFeatures(_ features: [FeatureFlag]) -> Bool {
        // FeatureFlags should contain all the features. If one or more is missing, we return false
        for feature in features {
            if !FeatureFlags.features.contains(feature) {
                return false // If FeatureFlags doesn't contain a flag, then the loop is over and we return false
            }
        }
        return true // If all FeaturesFlags contain all the features, then is has all the flags.
    }
}
