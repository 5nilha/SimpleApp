//
//  Logger.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

/// `Log` represents a log entry with various details about the log event.
struct Log: Encodable {
    
    /// `appHost` The application's host name or identifier.
    let appHost: String = Utils.appName
    /// `appInfo` A string combining the build number and version of the application.
    let appInfo: String = "Build: \(Utils.appBuildNumber), Version: \(Utils.appVersion)"
    /// `logLevel` The level of the log (e.g., debug, info, error).
    var logLevel: String?
    /// `occurrenceAt` The timestamp of when the log event occurred.
    let occurrenceAt: Date = Date()
    /// `logMessage` The primary message of the log.
    var logMessage: String?
    /// `description` An optional description providing more context about the log event.
    var description: String?
    /// `filename` The name of the file where the log event got triggered.
    var filename: String?
    /// `caller` The name of the function or method that triggered the log event.
    var caller: String?
    /// `line` The line number in the source code where the log event was triggered.
    var line: Int?
    /// `line` The line number in the source code where the log event was triggered.
    var currentThread: String? = "\(OperationQueue.current?.underlyingQueue?.label ?? "None") - \(Thread.current)"

    /// Prints the log to the console if the `enablePrintLogs` feature flag is active.
    func printLog() {
        guard FeatureFlags.hasFeature(.enablePrintLogs) else { return }
        
        let logComponents = [
            "************************************************************",
            "LOGGER -> \(appHost)",
            "APP_INFO: \(appInfo)",
            "LOG_LEVEL: \(logLevel ?? "")",
            "OCCURRENCE_AT: \(occurrenceAt)",
            threadDescription(),
            callerLineDescription(),
            "DESCRIPTION: \(description ?? "")",
            "LOG_MESSAGE: \(logMessage ?? "")",
            "************************************************************"
        ]
        
        print(logComponents.filter { !$0.isEmpty }.joined(separator: "\n"))
    }
    
    /// Helper method to format the caller and line information.
    private func callerLineDescription() -> String {
        guard let fileName = self.filename, let caller = self.caller, let line = self.line else { return "" }
        return "\nFILE_NAME: \(fileName)\nCALLER: \(caller)\nLINE: \(line)"
    }
    
    /// Helper method to format the caller and line information.
    private func threadDescription() -> String {
        guard FeatureFlags.hasFeature(.enableLogThreads), let currentThread =  self.currentThread else { return ""}
        return "\nCURRENT_THREAD: \(currentThread)"
    }
}

/// Defines the  log levels for log entries
enum LogLevel {
    case debug
    case info
    case queue
    case error(Error)

    /// Returns a string representation of the log level.
    var value: String {
        switch self {
        case .debug: return "Debug"
        case .info: return "Info"
        case .queue: return "Queue"
        case .error: return "Error"
        }
    }

    /// Provides a descriptive text for the log level, including error details if applicable.
    var description: String {
        switch self {
        case .debug: return "Debugging Log"
        case .info: return "Info Log"
        case .queue: return "Queue Log"
        case .error(let error):
            if let requestError = error as? RequestError {
                return "Error Log: \(requestError.logMessage)"
            } else {
                return "Error Log: [\(String(describing: error))]"
            }
        }
    }
    
    /// Determines if the current log level is enabled based on the active feature flags.
    func isEnabled() -> Bool {
        switch self {
        case .debug: return FeatureFlags.hasFeature(.enableLogDebugging)
        case .info: return FeatureFlags.hasFeature(.enableLogInfo)
        case .queue: return FeatureFlags.hasFeature(.enableLogThreads)
        case .error: return FeatureFlags.hasFeature(.enableLogError)
        }
    }
}

/// Manages the creation and asynchronous printing of log entries.
class Logger {
    
    /// A queue for handling log entries asynchronously, ensuring they don't block the main thread.
    static fileprivate let logQueue = DispatchQueue(label: "com.\(Utils.appName).logQueue")
    
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
                   fileName: String = #file,
                   caller: String = #function,
                   line: Int = #line) -> Log? {

        guard FeatureFlags.hasFeature(.enableLogs), logLevel.isEnabled() else { return nil }

        var log = Log(logLevel: logLevel.value,
                      logMessage: message,
                      description: logLevel.description,
                      filename: fileName.components(separatedBy: "/").last ?? fileName)
        
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
