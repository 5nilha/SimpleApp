//
//  RequestError.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

/// Represents errors that can occur during the network request process.
enum RequestError: Error, Equatable {
    case invalidData(Data?) /// Indicates that the data received from the server was invalid or corrupted.
    case invalidURL(String) /// Indicates that the URL provided for the network request is invalid.
    case networkError(Error) /// Represents an error encountered during the network request, including connectivity issues.
    case decodingError(Error) /// Indicates a failure in decoding the data returned from the server into the desired Decodable type.
    case serverError(statusCode: Int) /// Represents a server-side error, indicated by the HTTP status code.
    case responseUnsuccessful(URLResponse?)  /// Indicates that the server response was unsuccessful, but doesn't fit into other error categories like `invalidData` or `serverError`.
    case downloadImageError(Error)
    case unknownError(Error? = nil) /// Represents an error that does not fit any of the other categories, typically used as a fallback.
    
    var logMessage: String {
        switch self {
        case .invalidData(let data): return "Data received from the server was invalid, corrupted or not matching with pre-set models.\nData: \(String(describing: data))"
        case .invalidURL(let url): return "The URL provided for the network request is invalid.\nURL: \(url)"
        case .networkError(let error): return "The app encountered an issue during the network request, including connectivity.\nError: [\(error)]"
        case .decodingError(let error): return "The app Failed to decode the data returned from the server into the desired Decodable type.\nError: [\(error)]"
        case .serverError(let statusCode): return "The server response was unsuccessful.\nStatus code: \(statusCode)"
        case .responseUnsuccessful(let urlResponse): return "The server response was unsuccessful with an unknown response.\nURLResponse: \(String(describing: urlResponse))"
        case .downloadImageError(let error): return "Downloading Image from URL failed. Error: [\(error)]"
        case .unknownError(let error): return "The app encountered and unknown error.\(error != nil ? "\nError: [\(String(describing: error))]" : "")"
        }
    }
    
    var userMessage: String {
        switch self {
        case .downloadImageError:
            return "Unable to load image"
        default:
            return "Unable to load data"
        }
    }
    
    static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidData(let data1), .invalidData(let data2)): return data1 == data2
        case (.invalidURL(let url1), .invalidURL(let url2)): return url1 == url2
        case (.serverError(let code1), .serverError(let code2)): return code1 == code2
        case (.responseUnsuccessful(let response1), .responseUnsuccessful(let response2)): return response1 == response2
        case (.unknownError(let error1), .unknownError(let error2)): return error1?.localizedDescription == error2?.localizedDescription
        case (.networkError(let error1), .networkError(let error2)),
            (.decodingError(let error1), .decodingError(let error2)),
            (.downloadImageError(let error1), .downloadImageError(let error2)): return error1.localizedDescription == error2.localizedDescription
        default: return false
        }
    }
}
