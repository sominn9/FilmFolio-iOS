//
//  SearchViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/10.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: Constants
    
    struct Metric {
        static let collectionViewInset = 16.0
        static let collectionViewSpacing = 8.0
    }
    
    
    // MARK: Properties
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = String(localized: "Search Movie")
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.grid(
            spacing: Metric.collectionViewSpacing,
            inset: Metric.collectionViewInset
        )
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    // MARK: Methods
    
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationItem.title = String(localized: "Search")
        layout()
    }
    
    private func layout() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
    
}
