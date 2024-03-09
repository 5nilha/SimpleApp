//
//  ListPageCell.swift
//  SimpleApp
//
//  Created by Fabio Quintanilha on 3/5/24.
//

import UIKit

class ListPageCell: UITableViewCell {
    
    static let identifier: String = "ListPageCell"
    
    // MARK: - UI Constants
    enum UIDimensions {
        static let topMargin: CGFloat = 10
        static let sideMargin: CGFloat = 16
        static let bottomMargin: CGFloat = 10
        static let imageSize: CGFloat = 60
    }
    
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
        label.textColor =  ThemeManager.shared.currentTheme.textTitleColor
        label.font =  ThemeManager.shared.currentTheme.headLineFont
        label.textAlignment = .left
        label.accessibilityTraits = .staticText
        label.accessibilityIdentifier = "ListPageCellTitleLabel"
        label.isAccessibilityElement = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.textColor =  ThemeManager.shared.currentTheme.textBodyColor
        label.font =  ThemeManager.shared.currentTheme.captionFont
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
            gifImageView.widthAnchor.constraint(equalToConstant: UIDimensions.imageSize),
            gifImageView.heightAnchor.constraint(equalToConstant: UIDimensions.imageSize),
            gifImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIDimensions.sideMargin),
            titleLabel.topAnchor.constraint(equalTo: gifImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: gifImageView.trailingAnchor, constant: UIDimensions.sideMargin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIDimensions.sideMargin),
            tagsLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: UIDimensions.sideMargin),
            tagsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            tagsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIDimensions.bottomMargin)
        ])
        
        gifImageView.layer.cornerRadius = 12
    }
    
    func configure(with viewModel: ImageDetailViewModel?) {
        guard let vm = viewModel else { return }
        
        gifImageView.image = UIImage(named: "cat_blue_face")
        gifImageView.alpha = 0.6
        titleLabel.text = vm.title
        tagsLabel.text = vm.tags.joined(separator: ", ").uppercased()
        
        viewModel?.onImageDownloaded = { [weak self] imageData in
            self?.gifImageView.image = UIImage(data: imageData)
            self?.gifImageView.alpha = 1
        }
        viewModel?.loadData()
    }
}
