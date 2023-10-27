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
    
    private let disposeBag = DisposeBag()
    private let searcheView: SearchView
    private let searchViewModel: SearchViewModel<Item>
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
        configureSearchView()
        configureDataSource()
    }
    
    private func configureSearchView() {
        view.addSubview(searcheView)
        searcheView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
    }
    
    private func bind() {
        
        let input = SearchViewModel<Item>.Input(
            searchText: searcheView.searchBar.rx.text
                .orEmpty
                .distinctUntilChanged()
                .asObservable()
        )
        
        let output = searchViewModel.transform(input)
        
        output.items
            .subscribe(with: self, onNext: { owner, items in
                self.applySnapshot(items)
            })
            .disposed(by: disposeBag)
        
        searcheView.collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { $0.dataSource?.itemIdentifier(for: $1) }
            .subscribe(with: self, onNext: {
                $0.route($1)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func route(_ item: Item) {
        if let item = item as? Movie {
            let movieDetail = MovieDetailViewController(
                view: MovieDetailView(),
                viewModel: MovieDetailViewModel(id: item.id)
            )
            self.navigationController?.pushViewController(movieDetail, animated: true)
        } else if let item = item as? Series {
            let seriesDetail = SeriesDetailViewController(
                view: SeriesDetailView(),
                viewModel: SeriesDetailViewModel(id: item.id)
            )
            self.navigationController?.pushViewController(seriesDetail, animated: true)
        }
    }
    
}

// MARK: - DiffableDataSource

private extension SearchViewController {
    
    func applySnapshot(_ items: [Item]) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
            snapshot.appendSections([0])
            snapshot.appendItems(items)
            self.dataSource?.apply(snapshot)
        }
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RoundImageCell, Item> {
            if let posterURL = ($2 as? Movie)?.posterURL(size: .small) {
                $0.setup(posterURL)
            }
            if let posterURL = ($2 as? Series)?.posterURL(size: .small) {
                $0.setup(posterURL)
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
