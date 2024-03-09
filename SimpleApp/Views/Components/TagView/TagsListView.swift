//
//  TagsListView.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/6/24.
//

import UIKit

class TagsListView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum UIDimensions {
        static let height: CGFloat = 40
        static let cellPadding: CGFloat = 25
    }
    
    var tags: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
        
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
    
    func setupView() {
        backgroundColor = .white
        setupCollectionView()
        setConstraints()
    }
    
    func setupCollectionView() {
        safeAddSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
    }
    
    private func setConstraints() {
        if collectionView.superview != nil {
            NSLayoutConstraint.activate([
                collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: UIDimensions.height)
            ])
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = tags[indexPath.item]
        let cellPadding: CGFloat = UIDimensions.cellPadding
        let font = UIFont.preferredFont(forTextStyle: .caption1)
        let cellWidth = text.size(withAttributes: [NSAttributedString.Key.font: font]).width + cellPadding
        return CGSize(width: cellWidth, height: UIDimensions.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        let tag = tags[indexPath.item]
        cell.configure(with: tag)
        return cell
    }
}
