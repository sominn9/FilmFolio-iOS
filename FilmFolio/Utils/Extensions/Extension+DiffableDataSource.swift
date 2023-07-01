//
//  Extension+DiffableDataSource.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/02.
//

import UIKit

extension UICollectionViewDiffableDataSource {
    
    static func cellProvider<Cell>(using registration: UICollectionView.CellRegistration<Cell, ItemIdentifierType>) -> CellProvider {
        
        return { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
        }
    }
}

extension UICollectionView.SupplementaryRegistration where Supplementary == TitleView {
    
    static func registration(elementKind: String, title: String) -> Self {
        
        return .init(elementKind: elementKind) { titleView, elementKind, indexPath in
            
            titleView.titleLabel.text = title
        }
    }
}
