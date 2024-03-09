//
//  UIView+Extension.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/5/24.
//

import UIKit.UIView

extension UIView {
    enum Corner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        
        var mask: CACornerMask {
            switch self {
            case .topLeft: return CACornerMask.layerMinXMinYCorner
            case .topRight: return CACornerMask.layerMaxXMinYCorner
            case .bottomLeft: return CACornerMask.layerMinXMaxYCorner
            case .bottomRight: return CACornerMask.layerMaxXMaxYCorner
            }
        }
    }
    
    func roundCorners(corners: [Corner], radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        
        var maskedCorners: CACornerMask = []
        corners.forEach { maskedCorners.insert($0.mask) }
        layer.maskedCorners = maskedCorners
    }
    
    func safeAddSubview(_ view: UIView) {
        guard view.superview == nil else { return } // Avoiding the duplicated addition of the same view
        addSubview(view)
    }
}
