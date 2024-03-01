//
//  Logger.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

/// `Log` represents a log entry with various details about the log event.
struct Log: Encodable {
    
    /// The application's host name or identifier.
    let appHost: String = Utils.appName
    /// A string combining the build number and version of the application.
    let appInfo: String = "Build: \(Utils.appBuildNumber), Version: \(Utils.appVersion)"
    /// The level of the log (e.g., debug, info, error).
    var logLevel: String?
    /// The timestamp of when the log event occurred.
    let occurrenceAt: Date = Date()
    /// The primary message of the log.
    var logMessage: String?
    /// An optional description providing more context about the log event.
    var description: String?
    /// The name of the function or method that triggered the log event.
    var caller: String?
    /// The line number in the source code where the log event was triggered.
    var line: Int?
    
    /// Prints the log to the console if the `enablePrintLogs` feature flag is active.
    func printLog() {
        guard FeatureFlags.hasFeature(.enablePrintLogs) else { return }
        
        let logComponents = [
            "************************************************************",
            "LOGGER -> \(appHost)",
            "APP_INFO: \(appInfo)",
            "LOG_LEVEL: \(logLevel ?? "")",
            "OCCURRENCE_AT: \(occurrenceAt)",
            callerLineDescription(),
            "DESCRIPTION: \(description ?? "")",
            "LOG_MESSAGE: \(logMessage ?? "")",
            "************************************************************"
        ]
        
        print(logComponents.filter { !$0.isEmpty }.joined(separator: "\n"))
    }
    
    /// Helper method to format the caller and line information.
    private func callerLineDescription() -> String {
        guard let caller = caller, let line = line else { return "" }
        return "\nCALLER: \(caller)\nLINE: \(line)"
    }
}

/// Defines the  log levels for log entries
enum LogLevel {
    case debug
    case info
    case error(Error)

    /// Returns a string representation of the log level.
    var value: String {
        switch self {
        case .debug: return "Debug"
        case .info: return "Info"
        case .error: return "Error"
        }
    }

    /// Provides a descriptive text for the log level, including error details if applicable.
    var description: String {
        switch self {
        case .debug: return "Debugging Log"
        case .info: return "Info Log"
        case .error(let error): return "Error Log: [\(String(describing: error))]"
        }
    }
    
    /// Determines if the current log level is enabled based on the active feature flags.
    func isEnabled() -> Bool {
        switch self {
        case .debug: return FeatureFlags.hasFeature(.enableLogDebugging)
        case .info: return FeatureFlags.hasFeature(.enableLogInfo)
        case .error: return FeatureFlags.hasFeature(.enableLogError)
        }
    }
}

/// Manages the creation and asynchronous printing of log entries.
class Logger {
    
    /// A queue for handling log entries asynchronously, ensuring they don't block the main thread.
    static let logQueue = DispatchQueue(label: "com.\(Utils.appName).logQueue")
    
    /**
    Creates and optionally prints a log entry based on the provided details and the active feature flags.
    - Parameters:
    - message: The primary message of the log.]
    - logLevel: The severity level of the log. Default is .info
    - caller: The name of the function or method that triggered the log event.
    - line: The line number in the source code where the log event was triggered.
    - Returns: An optional `Log` instance if the log was created and printed; otherwise, `nil`.
    */
    @discardableResult
    class func log(_ message: String,
                    logLevel: LogLevel = .info,
                    caller: String = #function,
                    line: Int = #line) -> Log? {
        
        guard FeatureFlags.hasFeature(.enableLogs), logLevel.isEnabled() else { return nil }
        
        
        var log = Log(logLevel: logLevel.value,
                      logMessage: message,
                      description: logLevel.description)
        
        // Include caller and line information for error logs.
        if case .error = logLevel {
            log.caller = caller
            log.line = line
        }
        
        // Process the log asynchronously to avoid blocking the main thread.
        Logger.logQueue.async {
            log.printLog()
        }
        
        return log
    }
}
