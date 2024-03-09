//
//  BaseViewController.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/5/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var loadingSpinner: LoadingSpinnerView?
    
    lazy private var statusPopupBanner: StatusPopupBanner = {
        let banner = StatusPopupBanner()
        banner.alpha = .zero
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    private func commonInit() {
        Logger.log("\(type(of: self)) sucessfully initiated", logLevel: .debug)
        stylePresentation()
    }
    
    deinit {
        Logger.log("\(type(of: self)) sucessfully deinitialized", logLevel: .debug)
    }
    
    func stylePresentation() {
        modalPresentationStyle = .overFullScreen
        view.backgroundColor = ColorPalette.white
    }
    
    func addNavigationBackButton() {
        let image = UIImage(systemName: "arrow.left.circle.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(.gray)
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        barButtonItem.tintColor = ColorPalette.primary
        navigationItem.leftBarButtonItem = barButtonItem
    }

    @objc private func backButtonTapped() {
        if navigationController?.viewControllers.first == self {
            self.dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    /// Shows the loading spinner.
    final func showLoadingSpinner(withBackground background: UIColor? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let wSelf = self else { return }
            wSelf.loadingSpinner = LoadingSpinnerView()
            guard let loadingSpinner = wSelf.loadingSpinner else { return }
            loadingSpinner.translatesAutoresizingMaskIntoConstraints = false

            if background != nil {
                loadingSpinner.backgroundColor = background
            }

            loadingSpinner.stopLoading()
            wSelf.view.safeAddSubview(loadingSpinner)
            wSelf.setLoadingSpinnerConstraints()
            loadingSpinner.startLoading()
        }
    }

    var loadingSpinnerConstraints: BaseViewAnchors?

    func setLoadingSpinnerConstraints() {
        guard let loadingSpinner = self.loadingSpinner else { return }
        let constraints = loadingSpinner.constraints
        NSLayoutConstraint.deactivate(constraints)

        // Default Constraints are added to the bounds of super view. First check if loadingSpinnerConstraints was set, otherwise use default anchors
        let defaultAnchors = BaseViewAnchors(top: view.topAnchor,
                                             Bottom: view.bottomAnchor,
                                             leading: view.leadingAnchor,
                                             trailing: view.trailingAnchor)

        loadingSpinner.leadingAnchor.constraint(equalTo: loadingSpinnerConstraints?.leading ?? defaultAnchors.leading!).isActive = true
        loadingSpinner.trailingAnchor.constraint(equalTo: loadingSpinnerConstraints?.trailing ?? defaultAnchors.trailing!).isActive = true
        loadingSpinner.topAnchor.constraint(equalTo: loadingSpinnerConstraints?.top ?? defaultAnchors.top!).isActive = true
        loadingSpinner.bottomAnchor.constraint(equalTo: loadingSpinnerConstraints?.Bottom ?? defaultAnchors.Bottom!).isActive = true
    }

    final func dismissLoadingSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let wSelf = self else { return }
            guard let loadingSpinner = wSelf.loadingSpinner else { return }
            loadingSpinner.removeFromSuperview()
            loadingSpinner.stopLoading()
            NSLayoutConstraint.deactivate(loadingSpinner.constraints)
            wSelf.loadingSpinner = nil
        }
    }
    
    // Shows the status popup banner.
    func showStatusPopupBanner(text: String,
                               action: (() -> Void)? = nil,
                               dismissAction: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let wSelf = self else { return }
            wSelf.view.safeAddSubview(wSelf.statusPopupBanner)
            wSelf.statusPopupBanner.message = text
            wSelf.statusPopupBanner.alpha = .zero

            wSelf.statusPopupBanner.centerXAnchor.constraint(equalTo: wSelf.view.centerXAnchor).isActive = true
            wSelf.statusPopupBanner.bottomAnchor.constraint(equalTo: wSelf.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
            wSelf.statusPopupBanner.heightAnchor.constraint(equalToConstant: 30).isActive = true

            UIView.animate(withDuration: 0.2, animations: {
                wSelf.statusPopupBanner.alpha = 1.0
            }) { _ in
                action?()
            }
        }
    }

    /// Hides the status popup banner.
    func hideStatusPopupBanner(action: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let wSelf = self else { return }
            UIView.animate(withDuration: 0.5, animations: {
                wSelf.statusPopupBanner.alpha = 0.0
            }) { [weak self] _ in
                guard let wSelf = self else { return }
                NSLayoutConstraint.deactivate(wSelf.statusPopupBanner.constraints)
                wSelf.statusPopupBanner.removeFromSuperview()
                action?()
            }
        }
    }
}
