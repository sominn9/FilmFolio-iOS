//
//  ReviewListCell.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/09/01.
//

import SnapKit
import UIKit

final class ReviewListCell: UICollectionViewCell {
    
    struct Metric {
        static let cornerRadius = 16.0
        static let contentInset = 16.0
        static let backgroundAlpha = 0.65
    }
    
    
    // MARK: Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .lightGray
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Metric.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Methods
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        configureBackgroundImageView(contentView.frame.size)
    }
    
    func setup(_ review: Review) {
        titleLabel.text = review.title
        contentLabel.isHidden = review.content.isEmpty
        contentLabel.attributedText = review.content.withLineHeightMultiple(1.2)
        dateLabel.text = review.publishDate
        
        Task {
            guard let url = review.posterURL else { return }
            backgroundImageView.image = await ImageStorage.shared.image(for: url.absoluteString)
        }
    }
    
    private func configure() {
        contentView.layer.cornerRadius = Metric.cornerRadius
        contentView.backgroundColor = UIColor(named: "darkColor")
        contentView.addSubview(backgroundImageView)
        configureContentStackView()
    }
    
    private func configureContentStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            dateLabel,
            titleLabel,
            contentLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.layer.zPosition = 1
        stackView.setCustomSpacing(24, after: dateLabel)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges).inset(Metric.contentInset)
        }
    }
    
    private func configureBackgroundImageView(_ size: CGSize) {
        backgroundImageView.frame.size = .init(width: size.width, height: size.height)
        
        if backgroundImageView.subviews.isEmpty {
            let view = UIView(frame: backgroundImageView.frame)
            view.backgroundColor = UIColor(white: 0, alpha: Metric.backgroundAlpha)
            view.layer.cornerRadius = Metric.cornerRadius
            view.layer.masksToBounds = true
            backgroundImageView.addSubview(view)
        }
    }
    
}
