//
//  Extension+UICollectionViewCompositionalLayout.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/05/13.
//

import UIKit

extension UICollectionViewCompositionalLayout {
        
    static func carousel(spacing: CGFloat = 16.0) -> UICollectionViewCompositionalLayout {
        
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
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        }
    }
    
    static func grid(inset: CGFloat = 8.0) -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { _, env in

            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1 / 3),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1 / 2)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}
