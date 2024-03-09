//
//  MockAPIService.swift
//  SimpleAppTests
//
//  Created by Fabio Quintanilha on 3/8/24.
//

import XCTest
@testable import SimpleApp

class MockAPIService: APIService {
    
    var result: Result<[Cat], RequestError>?
    var downloadImageResult: Result<Data, RequestError>?
    
    func buildURLRequest(for url: URL, method: HttpMethod, queryItems: [String : String?]?, headers: [String : String]?, cachePolicy: URLRequest.CachePolicy, timeout: TimeInterval) -> URLRequest {
        return URLRequest(url: url)
    }
    
    func fetchItems<Model>(with request: URLRequest, of type: Model.Type, completion: @escaping RequestCompletion<Model>) where Model : Decodable {
        guard let result = result else { return }
        completion(result as! Result<Model, RequestError>)
    }
    
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, RequestError>) -> Void) {
        guard let downloadImageResult = downloadImageResult else { return }
        completion(downloadImageResult)
    }
    
    func cancelCurrentTask() {
        //Unimplmented
    }
}
