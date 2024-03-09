//
//  TagView.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/6/24.
//

import UIKit

class TagView: UIView {

    // MARK: - UI Constants
    enum UIDimensions {
        static let topMargin: CGFloat = 5
        static let sideMargin: CGFloat = 16
        static let bottomMargin: CGFloat = 5
        static let height: CGFloat = 30
    }
    
    var tagIndex: Int = 0
    
    var text: String? {
        didSet {
            setText()
        }
    }
    
    var textColor: UIColor = ColorPalette.white {
        didSet {
            textLabel.textColor = textColor
        }
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPalette.white
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.accessibilityTraits = .staticText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    private func setupView() {
        backgroundColor = ColorPalette.primary
        
        safeAddSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: UIDimensions.topMargin),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UIDimensions.bottomMargin),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIDimensions.sideMargin),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIDimensions.sideMargin)
        ])
    }
    
    
    private func setText() {
        textLabel.text = text
        textLabel.accessibilityValue = text
        textLabel.accessibilityIdentifier = "\(text ?? "\(tagIndex)")_textLabel_tag"
    }
}
