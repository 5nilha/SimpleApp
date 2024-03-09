//
//  ListViewModel.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/7/24.
//

import Foundation

protocol Requestable {
    var api: String { get }
    func loadData(for tag: String?)
}

extension Requestable {
    func loadData() {
        loadData(for: nil)
    }
}

open class ListViewModel: Requestable {
    
    var list: [ImageDetailViewModel] = []
    var requestManager: APIService?
    var onLoadData: ((Result<[ImageDetailViewModel], RequestError>) -> Void)?
    
    init(requestManager: APIService) {
        self.requestManager = requestManager
    }
    
    var numOfItems: Int {
        return list.count
    }
    
    func searchFor(tag: String?) -> [ImageDetailViewModel] {
        guard let searchedTag = tag, !searchedTag.isEmpty else { return list }
        let filteredList = list.filter { catViewModel in
            catViewModel.tags.contains(where: { $0.lowercased() == searchedTag.lowercased() })
        }
        if filteredList.isEmpty {
            loadData(for: tag)
            return list
        } else {
            return filteredList
        }
    }
    
    func selectItemAt(_ itemIndex: Int) -> ImageDetailViewModel? {
        guard list.count > itemIndex else { return nil }
        return list[itemIndex]
    }
    
    var api: String {
        return "https://cataas.com/api/cats"
    }
    
    func loadData(for tag: String? = nil) {
        let queryItems = tag != nil ? ["tags": tag] : nil
        guard let url = requestManager?.buildUrl(api: api),
              let request = requestManager?.buildURLRequest(for: url,
                                                            method: .get,
                                                            queryItems: queryItems)
            else { return }
        
        requestManager?.fetchItems(with: request, of: [ImageDetail].self, completion: { [weak self] result in
            guard let wself = self else  { return }
            switch result {
            case .success(let imagesDetails):
                wself.list = imagesDetails.map { ImageDetailViewModel(imageDetail: $0) }
                
                DispatchQueue.main.async {
                    wself.onLoadData?(.success(wself.list))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    wself.onLoadData?(.failure(error))
                }
            }
        })
    }
}
