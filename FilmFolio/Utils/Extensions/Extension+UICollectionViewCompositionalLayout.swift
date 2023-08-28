//
//  Extension+UICollectionViewCompositionalLayout.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/05/13.
//

import UIKit

extension UICollectionViewCompositionalLayout {

    /*
       +--------------------+ +------+
       |                    | |      |
       |                    | |      |
       |                    | |      |
       |                    | |      |
       |                    | |      |
       |                    | |      |
       |                    | |      | ....
       |                    | |      |
       |                    | |      |
       |                    | |      |
       |                    | |      |
       |                    | |      |
       +--------------------+ +------+
    */
        
    static func carousel(
        spacing: CGFloat = 16.0,
        inset: CGFloat = 16.0
    ) -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { _, _ in
            
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalHeight(2 / 3),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        }
    }
    
    /*
       +--------+ +--------+ +--------+
       |        | |        | |        |
       |        | |        | |        |
       |        | |        | |        |
       |        | |        | |        |
       +--------+ +--------+ +--------+
       +--------+ +--------+ +--------+
       |        | |        | |        |
       |        | |        | |        |
       |        | |        | |        |
       |        | |        | |        |
       +--------+ +--------+ +--------+
                      .
                      .
                      .
    */
    
    static func grid(
        spacing: CGFloat = 8.0,
        inset: CGFloat = 16.0,
        boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
    ) -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { _, env in

            let contentWidth = env.container.effectiveContentSize.width - inset * 2.0
            let count = 3.0 // column
            let itemWidth = (contentWidth - spacing * (count - 1.0)) / count
            
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .absolute(itemWidth),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(itemWidth * 3.0 / 2.0)
                ),
                subitems: [item]
            )
            
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
            section.boundarySupplementaryItems = boundarySupplementaryItems
            
            return section
        }
    }
    
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
