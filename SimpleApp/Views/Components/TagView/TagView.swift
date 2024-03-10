//
//  TagView.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/6/24.
//

import UIKit

class TagView: BaseView {

    // MARK: - UI Constants
    enum UIDimensions {
        static let topMargin: CGFloat = 5
        static let sideMargin: CGFloat = 16
        static let bottomMargin: CGFloat = 5
        static let height: CGFloat = 30
    }
    
    var text: String = "" {
        didSet {
            setText()
        }
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeManager.shared.currentTheme.secondaryColor
        label.font = ThemeManager.shared.currentTheme.captionFont
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
        backgroundColor =  ThemeManager.shared.currentTheme.primaryColor
        
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
        textLabel.accessibilityIdentifier = "\(text)_textLabel_tag"
    }
}
