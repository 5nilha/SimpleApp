//
//  RequestError.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

/// Represents errors that can occur during the network request process.
enum RequestError: Error {
    case invalidData /// Indicates that the data received from the server was invalid or corrupted.
    case invalidURL /// Indicates that the URL provided for the network request is invalid.
    case networkError(Error) /// Represents an error encountered during the network request, including connectivity issues.
    case decodingError(Error) /// Indicates a failure in decoding the data returned from the server into the desired Decodable type.
    case serverError(statusCode: Int) /// Represents a server-side error, indicated by the HTTP status code.
    case responseUnsuccessful  /// Indicates that the server response was unsuccessful, but doesn't fit into other error categories like `invalidData` or `serverError`.
    case unknownError /// Represents an error that does not fit any of the other categories, typically used as a fallback.
}
