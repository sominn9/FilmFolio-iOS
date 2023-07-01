//
//  Extension+NSCollectionLayoutBoundarySupplementaryItem.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/01.
//

import UIKit

extension NSCollectionLayoutBoundarySupplementaryItem {
    
    static func titleView(height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(height)
            ),
            elementKind: ElementKind.sectionHeader,
            alignment: .top
        )
    }
}
