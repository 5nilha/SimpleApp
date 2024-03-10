//
//  TagCell.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/6/24.
//

import UIKit

class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    let tagView: TagView = {
        let view = TagView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        contentView.safeAddSubview(tagView)
        contentView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            tagView.topAnchor.constraint(equalTo: tagView.topAnchor),
            tagView.bottomAnchor.constraint(equalTo: tagView.bottomAnchor, constant: -15),
            tagView.leadingAnchor.constraint(equalTo: tagView.leadingAnchor, constant: 15),
            tagView.trailingAnchor.constraint(equalTo: tagView.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        tagView.text = ""
    }
    
    func configure(with text: String) {
        tagView.text = text
    }
}
