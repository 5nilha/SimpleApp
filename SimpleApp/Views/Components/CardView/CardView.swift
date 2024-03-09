//
//  CardView.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/6/24.
//

import UIKit

class CardView: BaseView {
    
    // MARK: - UI Constants
    enum UIDimensions {
        static let topMargin: CGFloat = 70
        static let sideMargin: CGFloat = 16
        static let bottomMargin: CGFloat = 30
    }
    
    // MARK: Properties
    
    var title: String?  {
        didSet {
            setTitle()
        }
    }
    
    var image: UIImage? {
        didSet {
            setImage()
        }
    }
    
    var tags: [String]? {
        didSet {
            tagListView.tags = tags ?? []
        }
    }
    
    // MARK: UI Components
    private let mainStackView: UIStackView = {
        let vStack = UIStackView()
        vStack.alignment = .fill
        vStack.axis = .vertical
        vStack.spacing = 15
        vStack.backgroundColor = ThemeManager.shared.currentTheme.secondaryColor.withAlphaComponent(0.5)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    private let titleStackView: UIStackView = {
        let vStack = UIStackView()
        vStack.alignment = .fill
        vStack.axis = .vertical
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.shared.currentTheme.textTitleColor
        label.font = ThemeManager.shared.currentTheme.titleFont
        label.textAlignment = .center
        label.numberOfLines = 0
        label.accessibilityTraits = .staticText
        label.accessibilityIdentifier = "CardViewTitleLabel"
        label.isAccessibilityElement = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.shared.currentTheme.textBodyColor
        label.font = ThemeManager.shared.currentTheme.captionFont
        label.text = "Owned by"
        label.textAlignment = .center
        label.accessibilityTraits = .staticText
        label.accessibilityIdentifier = "CardViewSubtitleLabel"
        label.isAccessibilityElement = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let tagListView: TagsListView = {
        let listView = TagsListView()
        listView.backgroundColor = .clear
        listView.translatesAutoresizingMaskIntoConstraints = false
        return listView
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

    private func setupView() {
        safeAddSubview(cardImageView)
        safeAddSubview(mainStackView)
        titleStackView.addArrangedSubview(captionLabel)
        titleStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(titleStackView)
        
        
        setTags()
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UIDimensions.bottomMargin),
            mainStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setTitle() {
        titleLabel.isHidden = title == nil
        captionLabel.isHidden = title == nil
        titleLabel.text = title
    }
    
    private func setImage() {
        cardImageView.image = image
        if cardImageView.constraints.isEmpty && cardImageView.image != nil {
            NSLayoutConstraint.activate([
                cardImageView.topAnchor.constraint(equalTo: topAnchor),
                cardImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                cardImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                cardImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
    
    private func setTags() {
        mainStackView.addArrangedSubview(tagListView)
    }
}
