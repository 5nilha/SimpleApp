//
//  LoadingSpinnerView.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/7/24.
//

import UIKit

class LoadingSpinnerView: BaseView {

    var sourceTopAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>?
    var sourceBottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>?
    var sourceLeadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>?
    var sourceTrailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>?

    /** the activityIndicator itself is set as not an accessibility element since it's the container view that holds the actual loading indicator.
     Adjustments can be made to these accessibility labels and hints according to the app's context and the expected user experience.
    */
    var activityIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .black
        return loadingIndicator
    }()

    /// The color of the spinning indicator.
    var spinningColor: UIColor = .black {
        didSet {
            activityIndicator.color = spinningColor
        }
    }

    /// Initializes the view programmatically.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    /// Initializes the view from storyboard or nib.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    /// Initializes the view with a zero frame (convenience initializer).
    convenience init() {
        self.init(frame: .zero)
    }

    /// Sets up the UI elements and constraints.
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3) // Semi-transparent black background for the view
        isHidden = true
        setupAccessibility()
    }

    /// Starts the loading animation.
    func startLoading() {
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        isHidden = false
        updateAccessibility(isLoading: true)

        NSLayoutConstraint.deactivate(activityIndicator.constraints)

        // Center the activity indicator
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    /// Stops the loading animation.
    func stopLoading() {
        activityIndicator.stopAnimating()
        NSLayoutConstraint.deactivate(activityIndicator.constraints)
        isHidden = true
        activityIndicator.removeFromSuperview()
        updateAccessibility(isLoading: false)
    }

    private func setupAccessibility() {
        // Accessibility
        accessibilityIdentifier = "Loading Spinner"
        accessibilityLabel = "Loading Spinner" // Provide an appropriate label
        accessibilityTraits = .updatesFrequently // Notify VoiceOver that the spinner updates frequently
        isAccessibilityElement = true
        activityIndicator.isAccessibilityElement = false // The spinner itself is not an accessibility element
    }

    /// Updates accessibility properties based on the loading state.
    private func updateAccessibility(isLoading: Bool) {
        if isLoading {
            accessibilityLabel = "Loading in progress"
            accessibilityHint = "Loading spinner is active"
        } else {
            accessibilityLabel = "Loading stopped"
            accessibilityHint = "Loading spinner is now hidden"
        }
    }
}
