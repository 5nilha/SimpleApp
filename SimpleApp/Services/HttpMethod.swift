//
//  HttpMethod.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

/// Defines HTTP methods for network requests.
enum HttpMethod: String {
    case get = "GET" /// Represents an HTTP GET request, used for retrieving data.
    case post = "POST" /// Represents an HTTP POST request, used for submitting data to be processed.
    case put = "PUT" /// Represents an HTTP PUT request, used for updating or replacing data.
    case delete = "DELETE" /// Represents an HTTP DELETE request, used for deleting data.
}
