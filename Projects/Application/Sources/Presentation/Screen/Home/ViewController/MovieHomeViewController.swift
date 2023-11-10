//
//  MovieHomeViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/05/09.
//

import RxCocoa
import RxSwift
import UIKit
import Utils

enum MovieHomeSection: CustomStringConvertible, CaseIterable {
    case nowPlay
    case popular
    case topRated
    
    var description: String {
        switch self {
        case .nowPlay:  return ""
        case .popular:  return String(localized: "Popular Movies")
        case .topRated: return String(localized: "Top Rated Movies")
        }
    }
}

final class MovieHomeViewController: BaseViewController {
    
    enum Item: Hashable {
        case nowPlay(Movie)
        case popular(Movie)
        case topRated(Movie)
    }
    
    
    // MARK: Properties
    
    @Inject private var movieHomeView: MovieHomeView
    @Inject private var movieHomeViewModel: MovieHomeViewModel
    private var dataSource: UICollectionViewDiffableDataSource<MovieHomeSection, Item>?
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.movieHomeView.indexToSection = { [weak self] index in
            return self?.dataSource?.sectionIdentifier(for: index)
        }
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
        layout()
        configureDataSource()
        configureSupplementaryView()
    }
    
    private func bind() {
        let input = MovieHomeViewModel.Input(fetchMovies: Observable.just(()))
        
        let output = movieHomeViewModel.transform(input)
        
        output.nowPlaying
            .subscribe(with: self, onNext: { owner, movies in
                let items = movies.map { Item.nowPlay($0) }
                owner.applySnapshot(items, MovieHomeSection.nowPlay)
            })
            .disposed(by: disposeBag)
        
        output.popular
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, movies in
                let items = movies.map { Item.popular($0) }
                owner.applySnapshot(items, MovieHomeSection.popular)
            })
            .disposed(by: disposeBag)
        
        output.topRated
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, movies in
                let items = movies.map { Item.topRated($0) }
                owner.applySnapshot(items, MovieHomeSection.topRated)
            })
            .disposed(by: disposeBag)
        
        movieHomeView.collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { $0.dataSource?.itemIdentifier(for: $1) }
            .subscribe(with: self, onNext: {
                var id: Int? = nil
                
                switch $1 {
                case let .nowPlay(movie): id = movie.id
                case let .popular(movie): id = movie.id
                case let .topRated(movie): id = movie.id
                }
                
                guard let id else { return }
                let vc: MovieDetailViewController = DIContainer.shared.resolve(argument: id)
                $0.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func layout() {
        view.addSubview(movieHomeView)
        movieHomeView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }

}

// MARK: - DiffableDataSource

private extension MovieHomeViewController {
    
    func applySnapshot(_ items: [Item], _ section: MovieHomeSection) {
        DispatchQueue.main.async {
            guard var snapshot = self.dataSource?.snapshot() else { return }
            snapshot.appendItems(items, toSection: section)
            self.dataSource?.apply(snapshot)
        }
    }
    
    func configureDataSource() {
        let cellType1 = UICollectionView.CellRegistration<RoundImageCell, Item> { cell, _, item in
            if case let .nowPlay(movie) = item {
                cell.setup(movie.posterURL(size: .big))
            }
        }
        
        let cellType2 = UICollectionView.CellRegistration<RoundImageCell, Item> { cell, _, item in
            if case let .popular(movie) = item {
                cell.setup(movie.posterURL(size: .small))
            } else if case let .topRated(movie) = item {
                cell.setup(movie.posterURL(size: .small))
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<MovieHomeSection, Item>(
            collectionView: movieHomeView.collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                if let section = self?.dataSource?.sectionIdentifier(for: indexPath.section) {
                    switch section {
                    case .nowPlay:
                        return collectionView.dequeueConfiguredReusableCell(
                            using: cellType1,
                            for: indexPath,
                            item: item
                        )
                    case .popular, .topRated:
                        return collectionView.dequeueConfiguredReusableCell(
                            using: cellType2,
                            for: indexPath,
                            item: item
                        )
                    }
                }
                
                return nil
            }
        )
        
        var snapshot = NSDiffableDataSourceSnapshot<MovieHomeSection, Item>()
        snapshot.appendSections(MovieHomeSection.allCases)
        self.dataSource?.apply(snapshot)
    }
    
    func configureSupplementaryView() {
        let header = UICollectionView.SupplementaryRegistration<TitleView>(elementKind: ElementKind.sectionHeader.rawValue) {
            [weak self] titleView, elementKind, indexPath in
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            titleView.titleLabel.text = section?.description
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if let elementKind = ElementKind(rawValue: elementKind) {
                switch elementKind {
                case .sectionHeader:
                    return collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
                default:
                    break
                }
            }
            
            return nil
        }
    }
    
}
