//
//  ListPageViewController.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/4/24.
//

import UIKit

class ListPageViewController: BaseViewController, UISearchResultsUpdating {
    
    var listViewModel: ListViewModel?
    var serviceRequestManager: ServiceRequestManager = ServiceRequestManager.shared
    private var list: [Any] = []
    
    // MARK: - UI Constants
    enum UIDimensions {
        static let topMargin: CGFloat = 10
        static let sideMargin: CGFloat = 16
        static let bottomMargin: CGFloat = 0
        static let cellHeight: CGFloat = 100
    }
    
    // MARK: UI COMPONENTS
    let searchController = UISearchController(searchResultsController: nil)
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.shared.currentTheme.textTitleColor
        label.font = ThemeManager.shared.currentTheme.headLineFont
        label.textAlignment = .right
        label.accessibilityTraits = .staticText
        label.accessibilityIdentifier = "ListPageViewControllerTitleLabel"
        label.isAccessibilityElement = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var separator: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeManager.shared.currentTheme.primaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let listView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ListPageCell.self, forCellReuseIdentifier: ListPageCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorPalette.primary]
        }
    }
    
    private func setupUI() {
        navigationItem.title = "List"
        navigationItem.largeTitleDisplayMode = .always
        setupListView()
        setViewModel()
    }
    
    private func setupListView() {
        listView.delegate = self
        listView.dataSource = self
        
        view.safeAddSubview(listView)
        setHeadline()
        setSeparator()
        setSearchBar()
        
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            listView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(UIDimensions.bottomMargin))
        ])
    }
    
    private func setHeadline() {
        view.safeAddSubview(headlineLabel)
        setHeadlineText()
        
        NSLayoutConstraint.activate([
            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIDimensions.topMargin),
            headlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIDimensions.sideMargin),
            headlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func setHeadlineText() {
        let headlineText = "\(list.count) MATCHES"
        headlineLabel.text = headlineText
        headlineLabel.accessibilityValue = headlineText
    }
    
    private func setSeparator() {
        view.safeAddSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 3),
            separator.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 20),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setSearchBar() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for Tags"
        searchController.searchBar.accessibilityValue = "Search for Tags"
        searchController.searchBar.accessibilityTraits = .searchField
        searchController.searchBar.accessibilityIdentifier = "searchController"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setViewModel() {
        listViewModel = ListViewModel(requestManager: serviceRequestManager)
        showLoadingSpinner()
        listViewModel?.loadData()
        
        listViewModel?.onLoadData = { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showStatusPopupBanner(text: error.userMessage)
            default:
                self?.list = self?.listViewModel?.list ?? []
                self?.setHeadlineText()
                self?.listView.reloadData()
            }
            
            self?.dismissLoadingSpinner()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        list = listViewModel?.searchFor(tag: searchController.searchBar.text?.lowercased()) ?? []
        listView.reloadData()
    }
}

extension ListPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDimensions.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListPageCell.identifier, for: indexPath) as? ListPageCell
        else { return UITableViewCell() }
        let item = list[indexPath.item] as? ImageDetailViewModel
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.viewModel = list[indexPath.item] as? ImageDetailViewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
