//
//  SeriesHomeView.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/06.
//

import SnapKit
import UIKit

final class SeriesHomeView: UIView, SectionConvertible {
    
    // MARK: Constants

    struct Metric {
        static let interSectionSpacing: CGFloat = 20.0
        static let sectionHeaderHeight: CGFloat = 44.0
        static let carouselInterCardSpacing: CGFloat = 16.0
        static let carouselHorizontalInset: CGFloat = 16.0
        static let gridInterCardSpacing: CGFloat = 8.0
        static let gridHorizontalInset: CGFloat = 16.0
    }
    
    
    // MARK: Properties
    
    var indexToSection: ((Int) -> SeriesHomeSection?)?
    
    lazy var collectionView: UICollectionView = {
        let layout = collectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = false
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
    
    func configure() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] index, env in
            guard let section = self?.indexToSection?(index) else { return nil }
            
            switch section {
            case .trending:
                if let screenSize = self?.window?.windowScene?.screen.bounds {
                    return NSCollectionLayoutSection.carousel(
                        height: screenSize.height * 3.0 / 7.0,
                        interCardSpacing: Metric.carouselInterCardSpacing,
                        horizontalInset: Metric.carouselHorizontalInset
                    )
                }
            case .onTheAir, .topRated:
                return NSCollectionLayoutSection.grid(
                    environment: env,
                    interCardSpacing: Metric.gridInterCardSpacing,
                    horizontalInset: Metric.gridHorizontalInset,
                    boundarySupplementaryItems: [.titleView(height: Metric.sectionHeaderHeight)]
                )
            }
            
            return nil
        }
                                                         
        let config = layout.configuration
        config.interSectionSpacing = Metric.interSectionSpacing
        layout.configuration = config
        return layout
    }
    
}
