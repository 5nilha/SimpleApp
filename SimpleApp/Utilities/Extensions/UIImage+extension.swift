//
//  UIImage+extension.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/6/24.
//

import UIKit

extension UIImage {

    class func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        var images = [UIImage]()
        let count = CGImageSourceGetCount(source)

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
            }
        }

        return UIImage.animatedImage(with: images, duration: 2)
    }
}
