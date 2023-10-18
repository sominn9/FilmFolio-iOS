//
//  Extension+UICollectionViewCompositionalLayout.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/05/13.
//

import UIKit

extension UICollectionViewCompositionalLayout {
    
    static func list(spacing: CGFloat = 8.0, estimatedHeight: CGFloat) -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { _, env in
            
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(estimatedHeight)
                )
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(estimatedHeight)
                ),
                repeatingSubitem: item,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            return section
        }
    }
    
    static func tabBarLayout(itemWidth: CGFloat) -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { _, _ in
            
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1))
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .absolute(itemWidth),
                    heightDimension: .fractionalHeight(1)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        let config = layout.configuration
        config.scrollDirection = .horizontal
        layout.configuration = config
        
        return layout
    }
    
}
