//
//  ServiceRequestManager.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 2/29/24.
//

import Foundation

/// Defines a completion handler type alias for network requests, parameterized by a generic Decodable type.
typealias RequestCompletion<Model: Decodable> = (Result<Model, RequestError>) -> Void

/// Protocol defining the requirements for an API service, including a method to fetch items from a network request.
protocol APIService {
    func fetchItems<Model: Decodable>(with request: URLRequest, of type: Model.Type, completion: @escaping RequestCompletion<Model>)
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
    func fetchItems<Model: Decodable>(with request: URLRequest,
                                      of type: Model.Type,
                                      completion: @escaping RequestCompletion<Model>) {
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            Logger.log("Fetched Response: URLSession:dataTask", logLevel: .queue)
            guard let wself = self else { return }
            
            do {
                try wself.checkForError(error: error)
                try wself.checkURLResponse(response: response)
                let descodedData = try wself.decodeData(for: type, data: data)
                
                DispatchQueue.main.async {
                    completion(.success(descodedData))
                }
                
            } catch {
                let requestError = error as? RequestError ?? RequestError.unknownError(error)
                Logger.log("Error Fetching Response.", logLevel: .error(requestError))
                completion(.failure(requestError))
            }
        }
        task.resume()
    }
    
    // MARK: PRIVATE METHODS
    
    /// `checkForError(:)` Check for the existence of Errors in the server response
    /// If error is not nil, the method throws a RequestError
    /// - Parameters:
    ///   - error: A possible  error returned from the service.
    private func checkForError(error: Error?) throws {
        guard let err = error else { return }
        throw RequestError.networkError(err)
    }
    
    /// `checkURLResponse(:)` Checks and validates the URLResponse returned from the service
    ///  If response is invalid or has an error, the method throws a RequestError
    /// - Parameters:
    ///   - response: The URlResponse returned from the service.
    private func checkURLResponse(response: URLResponse?) throws {
        guard let httpResponse = response as? HTTPURLResponse else { throw RequestError.responseUnsuccessful(response) }
        guard 200...299 ~= httpResponse.statusCode else { throw RequestError.serverError(statusCode: httpResponse.statusCode) }
        return
    }
    
    /// `decodeData(:)` Decodes the data into a specified Decodable type passed into the argument.
    /// - Parameters:
    ///   - type: The type of the Decodable model to decode the data into.
    ///   - data: A data returned from the service to be decoded
    private func decodeData<Model: Decodable>(for type: Model.Type, data: Data?) throws -> Model {
        guard let data = data else {  throw RequestError.invalidData(data) }
        do {
            let decodedData = try JSONDecoder().decode(type.self, from: data)
            return decodedData
        } catch {
            throw RequestError.decodingError(error)
        }
    }
}
