//
//  ImageDetailViewModel.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/6/24.
//

import Foundation

class ImageDetailViewModel: Requestable {
    
    private var imageDetail: ImageDetail
    var requestManager: APIService?
    var onImageDownloadError: ((RequestError) -> Void)?
    var onImageDownloaded: ((Data) -> Void)?
    
    init(imageDetail: ImageDetail, requestManager: APIService? = ServiceRequestManager.shared) {
        self.requestManager = requestManager
        self.imageDetail = imageDetail
    }
    
    public var id: String {
        return imageDetail.id
    }

    public var tags: [String] {
        return imageDetail.tags.map{ $0.uppercased() }
    }
    
    public var title: String? {
        return imageDetail.title
    }
    
    public var caption: String? {
        return "Owned by"
    }

    public var imageData: Data?
    
    var api: String {
        return "https://cataas.com/cat/"
    }
    
    func loadData(for tag: String? = nil) {
        let endpoint = tag ?? id
        guard let url = requestManager?.buildUrl(api: api, endpoint: endpoint)
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
