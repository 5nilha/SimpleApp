//
//  ServiceRequestManager.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

/// Defines a completion handler type alias for network requests, parameterized by a generic Decodable type.
typealias RequestCompletion<T: Decodable> = (Result<T, RequestError>) -> Void

/// Protocol defining the requirements for an API service, including a method to fetch items from a network request.
protocol APIService {
    func fetchItems<T: Decodable>(with request: URLRequest, of type: T.Type, completion: @escaping RequestCompletion<T>)
}

/// ServiceRequestManager is  responsible for managing service requests to a network API.
class ServiceRequestManager: APIService {
    
    private let session: URLSession
        
    /// Initializes the service request manager with a URLSession injection. Defaults to the shared session.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Builds a URLRequest with the specified URL, HTTP method, and optional headers.
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method to be used for the request.
    ///   - headers: Optional dictionary of header fields to be added to the request.
    /// - Returns: A configured URLRequest.
    func buildURLRequest(for url: URL,
                      method: HttpMethod,
                      headers: [String: String]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    /// Fetches items from a network request and decodes them into a specified Decodable type.
    /// - Parameters:
    ///   - request: The URLRequest to fetch data from.
    ///   - type: The type of the Decodable model to decode the data into.
    ///   - completion: A closure called with the result of the fetch operation, returning either the decoded model or an error.
    func fetchItems<T: Decodable>(with request: URLRequest,
                                  of type: T.Type,
                                  completion: @escaping RequestCompletion<T>) {
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.networkError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(. responseUnsuccessful))
                    return
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        task.resume()
    }
}
