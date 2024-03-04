//
//  RequestError.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

/// Represents errors that can occur during the network request process.
enum RequestError: Error {
    case invalidData(Data?) /// Indicates that the data received from the server was invalid or corrupted.
    case invalidURL(URL) /// Indicates that the URL provided for the network request is invalid.
    case networkError(Error) /// Represents an error encountered during the network request, including connectivity issues.
    case decodingError(Error) /// Indicates a failure in decoding the data returned from the server into the desired Decodable type.
    case serverError(statusCode: Int) /// Represents a server-side error, indicated by the HTTP status code.
    case responseUnsuccessful(URLResponse?)  /// Indicates that the server response was unsuccessful, but doesn't fit into other error categories like `invalidData` or `serverError`.
    case unknownError(Error? = nil) /// Represents an error that does not fit any of the other categories, typically used as a fallback.
    
    var logMessage: String {
        switch self {
        case .invalidData(let data): return "Data received from the server was invalid, corrupted or not matching with pre-set models.\nData: \(String(describing: data))"
        case .invalidURL(let url): return "The URL provided for the network request is invalid.\nURL: \(url.absoluteString)"
        case .networkError(let error): return "The app encountered an issue during the network request, including connectivity.\nError: [\(error)]"
        case .decodingError(let error): return "The app Failed to decode the data returned from the server into the desired Decodable type.\nError: [\(error)]"
        case .serverError(let statusCode): return "The server response was unsuccessful.\nStatus code: \(statusCode)"
        case .responseUnsuccessful(let urlResponse): return "The server response was unsuccessful with an unknown response.\nURLResponse: \(String(describing: urlResponse))"
        case .unknownError(let error): return "The app encountered and unknown error.\(error != nil ? "\nError: [\(String(describing: error))]" : "")"
        }
    }
}
