//
//  SeriesDetailView.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/17.
//

import Common
import Resource
import SnapKit
import UIKit

final class SeriesDetailView: UIScrollView, SectionConvertible {
    
    // MARK: Constants
    
    struct Metric {
        static let stackViewInset: CGFloat = 8.0
        static let stackViewSpacing: CGFloat = 16.0
        static let componentSpacing: CGFloat = 20.0
        static let sectionHeaderHeight: CGFloat = 60.0
        static let collectionViewCellInset: CGFloat = 8.0
        static let collectionViewCellSpacing: CGFloat = 8.0
    }
    
    
    // MARK: Properties
    
    var indexToSection: ((Int) -> SeriesDetailSection?)?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = FFColor.darkColor
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
    
    func updateCollectionViewHeight() {
        self.collectionView.snp.updateConstraints {
            $0.height.equalTo(self.collectionView.contentSize.height)
        }
    }
    
    func setup(_ url: URL?) {
        Task {
            guard let url else { return }
            imageView.image = await ImageStorage.shared.image(for: url.absoluteString)
        }
    }
    
    private func configure() {
        configureContentView()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentInset.bottom = Metric.stackViewSpacing
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
            make.height.equalTo(100)
        }
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
            make.width.equalTo(self.snp.width)
        }
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
    
}

// MARK: - Private Extension

private extension SeriesDetailView {
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(Metric.sectionHeaderHeight)
            ),
            elementKind: ElementKind.sectionHeader.rawValue,
            alignment: .top
        )
        
        let layout = UICollectionViewCompositionalLayout { [weak self] index, env in
            var section: NSCollectionLayoutSection?
            
            if let detailViewSection = self?.indexToSection?(index) {
                switch detailViewSection {
                case .similar:
                    section = self?.makeSimilarSection(env)
                }
            }
            
            let inset = Metric.collectionViewCellInset
            section?.contentInsets = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
            section?.boundarySupplementaryItems = [header]
            section?.interGroupSpacing = Metric.collectionViewCellSpacing
            return section
        }
        
        let configuration = layout.configuration
        configuration.interSectionSpacing = Metric.componentSpacing
        layout.configuration = configuration
        return layout
    }
    
    func makeSimilarSection(_ env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let cellWidth = (env.container.effectiveContentSize.width
                         - Metric.collectionViewCellInset
                         - 3 * Metric.collectionViewCellSpacing) / 3.2
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(cellWidth),
                heightDimension: .absolute(cellWidth * 3.0 / 2.0)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return section
    }
    
}
