//
//  Extension+NSCollectionLayoutBoundarySupplementaryItem.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/01.
//

import UIKit
import Common

public extension NSCollectionLayoutBoundarySupplementaryItem {
    
    static func titleView(height: CGFloat, pin: Bool = true) -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(height)
            ),
            elementKind: ElementKind.sectionHeader.rawValue,
            alignment: .top
        )
        
        sectionHeader.pinToVisibleBounds = pin
        sectionHeader.zIndex = 2
        return sectionHeader
    }
    
}
