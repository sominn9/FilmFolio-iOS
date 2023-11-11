//
//  SearchView.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/12.
//

import SnapKit
import UIKit
import UIKitExtension

final class SearchView: UIView {
    
    // MARK: Constants
    
    struct Metric {
        static let inset = 16.0
        static let spacing = 8.0
    }
    
    
    // MARK: Properties
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16)
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, env in
            return NSCollectionLayoutSection.grid(
                environment: env,
                interCardSpacing: Metric.spacing,
                horizontalInset: Metric.inset
            )
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
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
            make.top.equalTo(self.snp.top)
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
