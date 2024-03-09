//
//  ListViewModel.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/7/24.
//

import Foundation

open class ListViewModel {
    
    var list: [CatViewModel] = []
    var requestManager: APIService?
    var onLoadData: ((Result<[CatViewModel], RequestError>) -> Void)?
    
    init(requestManager: APIService) {
        self.requestManager = requestManager
    }
    
    var numOfItems: Int {
        return list.count
    }
    
    func searchFor(tag: String?) -> [CatViewModel] {
        guard let searchedTag = tag, !searchedTag.isEmpty else { return list }
        let filteredList = list.filter { catViewModel in
            catViewModel.tags.contains(where: { $0.lowercased() == searchedTag.lowercased() })
        }
        if filteredList.isEmpty {
            loadData(tag: tag)
            return list
        } else {
            return filteredList
        }
    }
    
    func selectItemAt(_ itemIndex: Int) -> CatViewModel? {
        guard list.count > itemIndex else { return nil }
        return list[itemIndex]
    }
    
    func loadData(tag: String? = nil) {
        let queryItems = tag != nil ? ["tags": tag] : nil
        guard let url = URL(string: "https://cataas.com/api/cats"),
              let request = requestManager?.buildURLRequest(for: url,
                                                            method: .get,
                                                            queryItems: queryItems)
            else { return }
        requestManager?.fetchItems(with: request, of: [Cat].self, completion: { [weak self] result in
            guard let wself = self else  { return }
            switch result {
            case .success(let cats):
                wself.list = cats.map { CatViewModel(cat: $0) }
                
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
