//
//  CatViewModel.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/6/24.
//

import Foundation

class CatViewModel {
    
    private var cat: Cat
    var requestManager: APIService?
    var onImageDownloadError: ((RequestError) -> Void)?
    var onImageDownloaded: ((Data) -> Void)?
    
    init(cat: Cat, requestManager: APIService? = ServiceRequestManager.shared) {
        self.requestManager = requestManager
        self.cat = cat
    }
    
    private var id: String {
        return cat.id
    }

    public var tags: [String] {
        return cat.tags.map{ $0.uppercased() }
    }
    
    public var owner: String? {
        return cat.owner
    }

    public var imageData: Data?
    
    func downloadImage(for tag: String? = nil) {
        let endpoint = tag ?? id
        guard let url = URL(string: "https://cataas.com/cat/\(endpoint)")
        else { return }

        DispatchQueue.global().async { [weak self] in
            guard let wself = self else { return }
            wself.requestManager?.downloadImage(url, completion: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageData):
                        wself.imageData = imageData
                        wself.onImageDownloaded?(imageData)
                    case .failure(let error):
                        wself.onImageDownloadError?(error)
                    }
                }
            })
        }
    }
}
