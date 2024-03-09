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
    func buildURLRequest(for url: URL, method: HttpMethod, queryItems: [String: String?]?, headers: [String: String]?, cachePolicy: URLRequest.CachePolicy, timeout: TimeInterval) -> URLRequest
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, RequestError>) -> Void)
    func cancelCurrentTask()
}

extension APIService {
    func buildURLRequest(for url: URL, method: HttpMethod, queryItems: [String: String?]?) -> URLRequest? {
        buildURLRequest(for: url, method: method, queryItems: queryItems, headers: nil, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeout: 30)
    }
}

/// ServiceRequestManager is  responsible for managing service requests to a network API.
final class ServiceRequestManager: APIService {
    
    var session: URLSession = .shared
    private (set) var currentTask: URLSessionDataTask?
    private var tasks: [String: URLSessionDataTask] = [:]
    
    private static var privateShared: ServiceRequestManager?
    public class var shared: ServiceRequestManager {
        guard let uwShared = privateShared else {
            let newInstance = ServiceRequestManager()
            privateShared = newInstance
            return newInstance
        }
        return uwShared
    }

    public class func destroy() {
        privateShared = nil
    }
    
    public func resumeTask(task: URLSessionDataTask?) {
        guard let taskToResume = task else { return }
        tasks["\(taskToResume.taskIdentifier)"] = task
        currentTask = taskToResume
        taskToResume.resume()
    }
    
    public func cancelTask(task: URLSessionDataTask?) {
        guard let taskToCancel = task else { return }
        tasks.removeValue(forKey: "\(taskToCancel.taskIdentifier)")
        taskToCancel.cancel()
    }
    
    public func cancelCurrentTask() {
        currentTask?.cancel()
        endCurrentTask()
    }
    
    private func endCurrentTask() {
        guard let task = currentTask else { return }
        tasks.removeValue(forKey: "\(task.taskIdentifier)")
        currentTask = nil
    }
    
    /// Builds a URLRequest with the specified URL, HTTP method, and optional headers.
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method to be used for the request.
    ///   - headers: Optional dictionary of header fields to be added to the request.
    /// - Returns: A configured URLRequest.
    public func buildURLRequest(for url: URL,
                                 method: HttpMethod,
                                 queryItems: [String: String?]? = nil,
                                 headers: [String: String]? = nil,
                                 cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData,
                                 timeout: TimeInterval = 30) -> URLRequest {
       
        let components = buildURLComponents(urlString: url.absoluteString, queryItems: queryItems)
        let requestURL = components?.url ?? url
        
        var request = URLRequest(url: requestURL, cachePolicy: cachePolicy, timeoutInterval: timeout)
        request.httpMethod = method.rawValue
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    private func buildURLComponents(urlString: String, queryItems: [String: String?]?) -> URLComponents? {
        guard let query = queryItems, var components = URLComponents(string: urlString) else { return nil }
        components.queryItems = query.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        return components
    }
    
    // WARNING: This method happens in a background thread
    /// Fetches items from a network request and decodes them into a specified Decodable type.
    /// - Parameters:
    ///   - request: The URLRequest to fetch data from.
    ///   - type: The type of the Decodable model to decode the data into.
    ///   - completion: A closure called with the result of the fetch operation, returning either the decoded model or an error.
    public func fetchItems<Model: Decodable>(with request: URLRequest,
                                             of type: Model.Type,
                                             completion: @escaping RequestCompletion<Model>) {
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.global().async { [weak self] in
                Logger.log("Fetched Response: URLSession:dataTask", logLevel: .queue)
                guard let wself = self else { return }
                
                do {
                    try wself.checkForError(error: error)
                    try wself.checkURLResponse(response: response)
                    let descodedData = try wself.decodeData(for: type, data: data)
                    Logger.log("Fetched Response Successful.", logLevel: .info)
                    completion(.success(descodedData))
                    wself.endCurrentTask()
                    
                } catch {
                    let requestError = error as? RequestError ?? RequestError.unknownError(error)
                    Logger.log("Error Fetching Response.", logLevel: .error(requestError))
                    completion(.failure(requestError))
                    wself.endCurrentTask()
                }
            }
        }
        resumeTask(task: task)
    }
    
    // WARNING: This method happens in a background thread
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, RequestError>) -> Void) {
        
        // Check for cached data
        if let cachedData = ImageCacheManager.shared.getCachedImageData(for: url) {
            Logger.log("Retrieved image from ImageCacheManager: \(url.absoluteString)", logLevel: .info)
            completion(.success(cachedData))
            return
        }
        
        session.configuration.timeoutIntervalForRequest = 60
        Logger.log("Downloading image from URL: \(url.absoluteString)", logLevel: .info)
        let task = session.dataTask(with: url) { [weak self] (data, response,error) in
            DispatchQueue.global().async { [weak self] in
                guard let wself = self else { return }
                do {
                    try wself.checkForError(error: error)
                    try wself.checkURLResponse(response: response)
                    Logger.log("Fetched Image data Successful.", logLevel: .info)
                    let imageData = try wself.checkValidData(data: data)
                    ImageCacheManager.shared.cacheImageData(imageData, for: url)
                    completion(.success(imageData))
                    wself.endCurrentTask()
                    
                } catch {
                    let requestError = error as? RequestError ?? RequestError.unknownError(error)
                    Logger.log("Error in downloading image.", logLevel: .error(requestError))
                    completion(.failure(requestError))
                    wself.endCurrentTask()
                }
            }
        }
        resumeTask(task: task)
    }
    
    
    // MARK: CHECK RESPONSE METHODS
    
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
    
    private func checkValidData(data: Data?) throws -> Data {
        guard let validData = data else {  throw RequestError.invalidData(data) }
        return validData
    }
    
    /// `decodeData(:)` Decodes the data into a specified Decodable type passed into the argument.
    /// - Parameters:
    ///   - type: The type of the Decodable model to decode the data into.
    ///   - data: A data returned from the service to be decoded
    private func decodeData<Model: Decodable>(for type: Model.Type, data: Data?) throws -> Model {
        let validData = try checkValidData(data: data)
        do {
            let decodedData = try JSONDecoder().decode(type.self, from: validData)
            return decodedData
        } catch {
            throw RequestError.decodingError(error)
        }
    }
}
