//
//  StatusPopUpBanner.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/7/24.
//

import UIKit

/**
 A custom UIView subclass representing a status popup banner with icon and message capabilities.
 - Note: This class provides a customizable status banner that can display an icon and a message in a horizontally aligned stack view.
 */
final class StatusPopupBanner: BaseView {

    // MARK: - UI Constants
    enum UIDimensions {
        static let topMargin: CGFloat = 10
        static let sideMargin: CGFloat = 16
        static let bottomMargin: CGFloat = 10
        static let iconSize: CGFloat = 24
    }

    /// An optional UIImage to display as the icon on the banner.
    var icon: UIImage? {
        didSet {
            if icon != nil {
                setViewsOnStack()
            }
        }
    }

    /// A string representing the message to be displayed on the banner.
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }

    /// The stack view that holds the icon and message label.
    private var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()

    /// The image view used to display the icon.
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.accessibilityIdentifier = "StatusPopupIcon"
        imageView.accessibilityTraits = .image
        return imageView
    }()

    /// The label used to display the message.
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = ColorPalette.gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.accessibilityIdentifier = "StatusPopupMessage"
        label.accessibilityTraits = .staticText
        return label
    }()

    /// Initializes the StatusPopupBanner with a frame.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    /// Initializes the StatusPopupBanner from a coder.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    /// Convenience initializer to create StatusPopupBanner with a zero frame.
    public convenience init() {
        self.init(frame: .zero)
    }

    /// Overrides the layoutSubviews method to update corner radius on view bounds change.
    public override func layoutSubviews() {
        super.layoutSubviews()
        setCorners()
    }
}

//MARK: Set and Config Views
extension StatusPopupBanner {
    /// Sets up the view's appearance and components.
    private func setupView() {
        setOuterView()
        setViewProperties()
        setCorners()
        setViewsOnStack()
        addBottomShadow()
    }

    /// Sets initial properties for the view.
    private func setViewProperties() {
        accessibilityIdentifier = "StatusPopupBanner"
        backgroundColor = UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0, alpha: 1) //Default color
    }

    /// Adds the outer stack view and its constraints to the view.
    private func setOuterView() {
        addSubview(outerStack)
        NSLayoutConstraint.activate([
            outerStack.topAnchor.constraint(equalTo: topAnchor, constant: UIDimensions.topMargin),
            outerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIDimensions.bottomMargin),
            outerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIDimensions.sideMargin),
            outerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIDimensions.sideMargin)
        ])
    }

    /// Configures and adds icon and message views to the stack.
    private func setViewsOnStack() {
        setIconView()
        setMessageView()
    }

    /// Configures the icon view and adds it to the stack.
    private func setIconView() {
        guard let icon = self.icon else { return }
        outerStack.removeArrangedSubview(iconImageView)
        outerStack.addArrangedSubview(iconImageView)
        iconImageView.image = icon

        if !iconImageView.widthAnchor.constraint(equalToConstant: UIDimensions.iconSize).isActive {
            iconImageView.widthAnchor.constraint(equalToConstant: UIDimensions.iconSize).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: UIDimensions.iconSize).isActive = true
        }
    }

    /// Configures the message view and adds it to the stack.
    private func setMessageView() {
        outerStack.removeArrangedSubview(messageLabel)
        outerStack.addArrangedSubview(messageLabel)
        messageLabel.text = message
    }

    /// Sets corners and border width to the view
    private func setCorners() {
        layer.cornerRadius = bounds.height / 2
    }

    /// add shadow for the bottom of the popup banner
    private func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 2) // Adjust the offset to control the shadow position
        layer.shadowRadius = 2 // Adjust the radius to control the blurriness of the shadow
    }
}
