//
//  DetailsViewController.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/5/24.
//

import UIKit

class DetailsViewController: BaseViewController {
    
    var requestManager = ServiceRequestManager.shared
    var viewModel: ImageDetailViewModel?
    
    let cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(requestManager: ServiceRequestManager = ServiceRequestManager.shared) {
        self.requestManager = requestManager
        super.init(nibName: nil, bundle: nil)
    }
       
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addNavigationBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewModel()
        setCardView()
    }
    
    private func setupViewModel() {
        viewModel?.requestManager = ServiceRequestManager.shared
        viewModel?.onImageDownloadError = { [weak self] error in
            self?.dismissLoadingSpinner()
            self?.showStatusPopupBanner(text: error.userMessage)
        }
        
        loadingSpinnerConstraints = BaseViewAnchors.init(top: cardView.cardImageView.topAnchor,
                                                         Bottom: cardView.cardImageView.bottomAnchor,
                                                         leading: cardView.cardImageView.leadingAnchor,
                                                         trailing: cardView.cardImageView.trailingAnchor)

        viewModel?.onImageDownloaded = { [weak self] imageData in
            self?.dismissLoadingSpinner()
            self?.cardView.image = UIImage.gif(data: imageData)
            self?.cardView.cardImageView.alpha = 1
        }

        showLoadingSpinner(withBackground: .clear)
        viewModel?.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        requestManager.cancelCurrentTask()
    }
    
    private func setupView() {
        view.safeAddSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setCardView() {
        cardView.image = UIImage(named: "cat")
        cardView.cardImageView.alpha = 0.4
        cardView.tags = viewModel?.tags
        cardView.title = viewModel?.title
    }
}
