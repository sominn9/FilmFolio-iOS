//
//  MovieHomeViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/05/09.
//

import RxCocoa
import RxSwift
import UIKit

final class MovieHomeViewController: UIViewController {
    
    enum Section: Int, CustomStringConvertible, CaseIterable {
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
    
    enum Item: Hashable {
        case nowPlay(Movie)
        case popular(Movie)
        case topRated(Movie)
    }
    
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let movieHomeView: MovieHomeView
    private let movieHomeViewModel: MovieHomeViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    
    // MARK: Initializing
    
    init(view: MovieHomeView, viewModel: MovieHomeViewModel) {
        self.movieHomeView = view
        self.movieHomeViewModel = viewModel
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
        view.addSubview(movieHomeView)
        movieHomeView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        configureDataSource()
        configureSupplementaryView()
    }
    
    private func bind() {
        
        let input = MovieHomeViewModel.Input(fetchMovies: Observable.just(()))
        
        let output = movieHomeViewModel.transform(input)
        
        output.nowPlaying
            .subscribe(with: self, onNext: { owner, movies in
                let items = movies.map { Item.nowPlay($0) }
                owner.applySnapshot(items, .nowPlay)
            })
            .disposed(by: disposeBag)
        
        output.popular
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, movies in
                let items = movies.map { Item.popular($0) }
                owner.applySnapshot(items, .popular)
            })
            .disposed(by: disposeBag)
        
        output.topRated
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, movies in
                let items = movies.map { Item.topRated($0) }
                owner.applySnapshot(items, .topRated)
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
                let view = MovieDetailView()
                let vm = MovieDetailViewModel(id: id)
                let vc = MovieDetailViewController(view: view, viewModel: vm)
                $0.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
    }

}

// MARK: - DiffableDataSource

private extension MovieHomeViewController {
    
    func applySnapshot(_ items: [Item], _ section: Section) {
        DispatchQueue.main.async {
            if var snapshot = self.dataSource?.snapshot(for: section) {
                snapshot.append(items)
                self.dataSource?.apply(snapshot, to: section)
            }
        }
    }
    
    func configureDataSource() {
        let cellType1 = UICollectionView.CellRegistration<RoundImageCell, Item> { cell, _, item in
            if case let .nowPlay(movie) = item {
                cell.setup(movie.posterPath(size: .big))
            }
        }
        
        let cellType2 = UICollectionView.CellRegistration<RoundImageCell, Item> { cell, _, item in
            if case let .popular(movie) = item {
                cell.setup(movie.posterPath(size: .small))
            } else if case let .topRated(movie) = item {
                cell.setup(movie.posterPath(size: .small))
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: movieHomeView.collectionView,
            cellProvider: { collectionView, indexPath, item in
                if indexPath.section == 0 {
                    return collectionView.dequeueConfiguredReusableCell(
                        using: cellType1,
                        for: indexPath,
                        item: item
                    )
                } else {
                    return collectionView.dequeueConfiguredReusableCell(
                        using: cellType2,
                        for: indexPath,
                        item: item
                    )
                }
            }
        )
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        self.dataSource?.apply(snapshot)
    }
    
    func configureSupplementaryView() {
        let popularSectionHeader = UICollectionView.SupplementaryRegistration<TitleView>.registration(
            elementKind: ElementKind.sectionHeader.rawValue,
            title: Section.popular.description
        )
        
        let topRatedSectionHeader = UICollectionView.SupplementaryRegistration<TitleView>.registration(
            elementKind: ElementKind.sectionHeader.rawValue,
            title: Section.topRated.description
        )
        
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if let section = Section(rawValue: indexPath.section) {
                switch section {
                case .popular:
                    return collectionView.dequeueConfiguredReusableSupplementary(
                        using: popularSectionHeader,
                        for: indexPath
                    )
                case .topRated:
                    return collectionView.dequeueConfiguredReusableSupplementary(
                        using: topRatedSectionHeader,
                        for: indexPath
                    )
                default:
                    break
                }
            }
            
            return nil
        }
    }
    
}
