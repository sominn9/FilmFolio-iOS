//
//  MovieDetailView.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/14.
//

import SnapKit
import UIKit

final class MovieDetailView: UIView {
    
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
    
    lazy var releaseDateLabel: UILabel = {
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
        configureStackViewItemsInset(stackView)
        configureScrollView(stackView)
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [
                imageView,
                titleLabel,
                overviewLabel,
                releaseDateLabel,
                genreLabel
            ]
        )
        
        stackView.axis = .vertical
        stackView.spacing = Metric.spacing
        stackView.setCustomSpacing(Metric.spacing + 4, after: imageView)
        return stackView
    }
    
    private func configureScrollView(_ stackView: UIStackView) {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.snp.edges)
            make.width.equalTo(scrollView.snp.width)
        }
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
    }
    
    private func configureStackViewItemsInset(_ stackView: UIStackView) {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(stackView.snp.left).inset(Metric.inset)
            make.right.equalTo(stackView.snp.right).inset(Metric.inset)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.left.equalTo(stackView.snp.left).inset(Metric.inset)
            make.right.equalTo(stackView.snp.right).inset(Metric.inset)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.left.equalTo(stackView.snp.left).inset(Metric.inset)
            make.right.equalTo(stackView.snp.right).inset(Metric.inset)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.left.equalTo(stackView.snp.left).inset(Metric.inset)
            make.right.equalTo(stackView.snp.right).inset(Metric.inset)
        }
    }
    
}
