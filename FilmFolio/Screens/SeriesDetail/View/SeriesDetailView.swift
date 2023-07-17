//
//  SeriesDetailView.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/17.
//

import SnapKit
import UIKit

final class SeriesDetailView: UIScrollView {
    
    // MARK: Constants
    
    struct Metric {
        static let spacing: CGFloat = 16.0
        static let inset: CGFloat = 8.0
    }
    
    
    // MARK: Properties
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(named: "darkColor")
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
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var firstAirDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    lazy var numberOfEpisodesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
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
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let height = self.window?.windowScene?.screen.bounds.height {
            imageView.snp.makeConstraints {
                $0.height.equalTo(height * 0.3)
            }
        }
    }
    
    func setup(_ urlString: String?) {
        Task {
            guard let urlString else { return }
            imageView.image = await ImageStorage.shared.image(for: urlString)
        }
    }
    
    private func configure() {
        let stackView = createStackView()
        configureContentView(stackView)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentInset.bottom = Metric.spacing
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                overviewLabel,
                firstAirDateLabel,
                numberOfEpisodesLabel,
                genreLabel
            ]
        )
        
        stackView.axis = .vertical
        stackView.spacing = Metric.spacing
        return stackView
    }
    
    private func configureContentView(_ stackView: UIStackView) {
        let contentView = UIView()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(contentView.snp.top)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(Metric.inset)
            make.right.equalTo(contentView.snp.right).inset(Metric.inset)
            make.top.equalTo(imageView.snp.bottom).offset(Metric.spacing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
            make.width.equalTo(self.snp.width)
        }
    }
    
}
