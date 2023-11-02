//
//  UpcomingListView.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/17.
//

import SnapKit
import UIKit

final class UpcomingListView: UIView {
    
    // MARK: Properties
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .list(estimatedHeight: 400))
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
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
    
    private func configure() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
    }
    
}
