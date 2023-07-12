//
//  SearchView.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/12.
//

import SnapKit
import UIKit

final class SearchView: UIView {
    
    // MARK: Constants
    
    struct Metric {
        static let collectionViewInset = 16.0
        static let collectionViewSpacing = 8.0
    }
    
    
    // MARK: Properties
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.grid(
            spacing: Metric.collectionViewSpacing,
            inset: Metric.collectionViewInset
        )
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    // MARK: Initializing
    
    init(placeholder: String) {
        super.init(frame: .zero)
        configure()
        searchBar.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Methods
    
    private func configure() {
        self.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
    }
    
}
