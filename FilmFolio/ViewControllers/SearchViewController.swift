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

final class SearchViewController<Item: Hashable>: UIViewController {
    
    // MARK: Properties
    
    private let searcheView: SearchView
    private let searchViewModel: SearchViewModel<Item>
    private let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>?
    
    
    // MARK: Initializing
    
    init(view: SearchView, viewModel: SearchViewModel<Item>) {
        self.searcheView = view
        self.searchViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    
    // MARK: Methods
    
    private func configure() {
        view.addSubview(searcheView)
        searcheView.frame = view.bounds
        configureDataSource()
    }
    
    private func bind() {
        let input = SearchViewModel<Item>.Input(
            searchText: searcheView.searchBar.rx.text.map { $0 ?? "" }
        )
        
        _ = searchViewModel.transform(input)
    }
    
}

// MARK: - DiffableDataSource

private extension SearchViewController {
    
    func applySnapshot(_ items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        self.dataSource?.apply(snapshot)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RoundImageCell, Item> { cell, indexPath, item in
            if let posterPath = (item as? Movie)?.posterPath(size: .small) {
                cell.setup(posterPath)
            }
            if let posterPath = (item as? Series)?.posterPath(size: .small) {
                cell.setup(posterPath)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Item>(
            collectionView: self.searcheView.collectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
    }
    
}
