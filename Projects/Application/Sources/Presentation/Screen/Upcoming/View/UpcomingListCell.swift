//
//  UpcomingListCell.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/18.
//

import Resource
import SnapKit
import UIKit

final class UpcomingListCell: UICollectionViewCell {
    
    // MARK: Constants
    
    struct Metric {
        static let spacing: CGFloat = 12.0
        static let inset: CGFloat = 16.0
        static let cornerRadius: CGFloat = 8.0
    }
    
    
    // MARK: Properties
    
    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = FFColor.accentColor
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = FFColor.darkColor
        imageView.layer.cornerRadius = Metric.cornerRadius
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        return label
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
    
    func setup(_ url: URL?) {
        Task {
            guard let url else { return }
            imageView.image = await ImageStorage.shared.image(for: url.absoluteString)
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let height = self.window?.windowScene?.screen.bounds.height {
            imageView.snp.makeConstraints {
                $0.height.equalTo(height * 0.3)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func configure() {
        let stackView = createStackView()
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges).inset(Metric.inset)
        }
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [
                releaseDateLabel,
                imageView,
                titleLabel,
                overviewLabel
            ]
        )
        
        stackView.axis = .vertical
        stackView.spacing = Metric.spacing
        stackView.setCustomSpacing(Metric.spacing + 4.0, after: imageView)
        return stackView
    }
    
}
