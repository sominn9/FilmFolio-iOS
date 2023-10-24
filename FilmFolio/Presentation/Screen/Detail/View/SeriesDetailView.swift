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
        static let stackViewInset: CGFloat = 8.0
        static let stackViewSpacing: CGFloat = 16.0
        static let componentSpacing: CGFloat = 20.0
        static let sectionHeaderHeight: CGFloat = 60.0
        static let collectionViewHeight: CGFloat = 250.0
        static let collectionViewCellInset: CGFloat = 8.0
        static let collectionViewCellSpacing: CGFloat = 8.0
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
    
    lazy var collectionView: UICollectionView = {
        let layout = collectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
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
        configureContentView()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentInset.bottom = Metric.stackViewSpacing
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
        stackView.spacing = Metric.stackViewSpacing
        return stackView
    }
    
    private func configureContentView() {
        let contentView = UIView()
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(contentView.snp.top)
        }
        
        let stackView = createStackView()
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(Metric.stackViewInset)
            make.right.equalTo(contentView.snp.right).inset(Metric.stackViewInset)
            make.top.equalTo(imageView.snp.bottom).offset(Metric.componentSpacing)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(stackView.snp.bottom).offset(Metric.componentSpacing)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(Metric.collectionViewHeight)
        }
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
            make.width.equalTo(self.snp.width)
        }
    }
    
}

// MARK: - Private Extension

private extension SeriesDetailView {
    
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(Metric.sectionHeaderHeight)
            ),
            elementKind: ElementKind.sectionHeader.rawValue,
            alignment: .top
        )
        
        return UICollectionViewCompositionalLayout { index, env in
            
            let containerWidth = env.container.effectiveContentSize.width
            var cellWidth = (containerWidth
                             - Metric.collectionViewCellInset
                             - 3 * Metric.collectionViewCellSpacing) / 3.2
            cellWidth = round(cellWidth)
            
            switch index {
            case 0:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .absolute(cellWidth),
                        heightDimension: .absolute(cellWidth * 3.0 / 2.0)
                    ),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.boundarySupplementaryItems = [header]
                section.interGroupSpacing = Metric.collectionViewCellSpacing
                section.contentInsets = .init(
                    top: 0,
                    leading: Metric.collectionViewCellInset,
                    bottom: 0,
                    trailing: Metric.collectionViewCellInset
                )
                
                return section
                
            default:
                fatalError()
            }
        }
    }
    
}
