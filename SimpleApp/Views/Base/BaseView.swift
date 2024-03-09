//
//  BaseView.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/7/24.
//

import UIKit

struct BaseViewAnchors {
    var top: NSLayoutAnchor<NSLayoutYAxisAnchor>?
    var Bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>?
    var leading: NSLayoutAnchor<NSLayoutXAxisAnchor>?
    var trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>?
}

class BaseView: UIView {

    // MARK: - Initialization
    /// Initializes the BaseView with a frame.
    /// - Parameter frame: The initial frame for the base view.
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    /// Initializes the BaseView from data in a given unarchiver (coder).
    /// - Parameter coder: An unarchiver object.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    /// Initializes the BaseView with a zero frame (convenience initializer).
    convenience init() {
        self.init(frame: .zero)
    }

    /// Common initialization method called from various initializers.
    func commonInit() {
        Logger.log("\(type(of: self)) successfully initialized", logLevel: .debug)
    }

    deinit {
        Logger.log("\(type(of: self)) successfully deinitialized.\n\(String(describing: self))", logLevel: .debug)
    }
}
