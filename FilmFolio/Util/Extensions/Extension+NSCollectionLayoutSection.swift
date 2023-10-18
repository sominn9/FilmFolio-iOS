//
//  Extension+NSCollectionLayoutSection.swift
//  FilmFolio
//
//  Created by 신소민 on 10/16/23.
//

import UIKit

extension NSCollectionLayoutSection {
    
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
        height: CGFloat,
        interCardSpacing: CGFloat = 16.0,
        horizontalInset: CGFloat = 16.0
    ) -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(height * (2 / 3)),
                heightDimension: .absolute(height)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = interCardSpacing
        section.contentInsets = .init(top: 0, leading: horizontalInset, bottom: 0, trailing: horizontalInset)
        return section
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
        environment: NSCollectionLayoutEnvironment,
        interCardSpacing: CGFloat = 8.0,
        horizontalInset: CGFloat = 16.0,
        boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
    ) -> NSCollectionLayoutSection {
        
        let contentWidth = environment.container.effectiveContentSize.width - horizontalInset * 2.0
        let count = 3.0 // column
        let itemWidth = (contentWidth - interCardSpacing * (count - 1.0)) / count
        
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
        
        group.interItemSpacing = .fixed(interCardSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interCardSpacing
        section.boundarySupplementaryItems = boundarySupplementaryItems
        section.contentInsets = .init(top: 0, leading: horizontalInset, bottom: 0, trailing: horizontalInset)
        return section
    }
    
    
    static func list(spacing: CGFloat = 8.0, estimatedHeight: CGFloat) -> NSCollectionLayoutSection {
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
