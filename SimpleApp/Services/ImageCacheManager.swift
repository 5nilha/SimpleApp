//
//  ImageCacheManager.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/7/24.
//

import Foundation

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {} // Private initialization to ensure singleton
    
    private var cache = NSCache<NSURL, NSData>()
        
    func cacheImageData(_ data: Data, for url: URL) {
        Logger.log("Caching image for URL: \(url.absoluteString)", logLevel: .info)
        cache.setObject(data as NSData, forKey: url as NSURL)
    }
    
    func getCachedImageData(for url: URL) -> Data? {
        return cache.object(forKey: url as NSURL) as Data?
    }
}
