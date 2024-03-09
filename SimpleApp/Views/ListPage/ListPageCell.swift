//
//  ListPageCell.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/5/24.
//

import UIKit

class ListPageCell: UITableViewCell {
    
    static let identifier: String = "ListPageCell"
    
    let gifImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "cat")
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorPalette.darkGray
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        label.accessibilityTraits = .staticText
        label.accessibilityIdentifier = "ListPageCellTitleLabel"
        label.isAccessibilityElement = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorPalette.gray
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textAlignment = .left
        label.accessibilityTraits = .staticText
        label.numberOfLines = 0
        label.accessibilityIdentifier = "ListPageCellTagsLabel"
        label.isAccessibilityElement = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImageView.image = nil
        titleLabel.text = nil
        tagsLabel.text = nil
    }
    
    private func setupView() {
        backgroundColor = ColorPalette.white
        safeAddSubview(gifImageView)
        safeAddSubview(titleLabel)
        safeAddSubview(tagsLabel)
        applyConstraints()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            gifImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            gifImageView.widthAnchor.constraint(equalToConstant: 60),
            gifImageView.heightAnchor.constraint(equalToConstant: 60),
            gifImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: gifImageView.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: gifImageView.trailingAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            tagsLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 15),
            tagsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            tagsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        gifImageView.layer.cornerRadius = 12
    }
    
    func configure(with viewModel: CatViewModel?) {
        guard let vm = viewModel else { return }
        
        gifImageView.image = UIImage(named: "cat_blue_face")
        gifImageView.alpha = 0.6
        titleLabel.text = vm.owner
        tagsLabel.text = vm.tags.joined(separator: ", ").uppercased()
        
        viewModel?.onImageDownloaded = { [weak self] imageData in
            self?.gifImageView.image = UIImage(data: imageData)
            self?.gifImageView.alpha = 1
        }
        viewModel?.downloadImage()
    }
}
