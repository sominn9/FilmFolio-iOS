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
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let movieHomeView: MovieHomeView
    private let movieHomeViewModel: MovieHomeViewModel
    private var nowPlayDataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    private var popularDataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    private var topRatedDataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    
    
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
        
        let input = MovieHomeViewModel.Input(
            fetchNowPlayMovies: Observable.just(()),
            fetchPopularMovies: Observable.just(()),
            fetchTopRatedMovies: Observable.just(())
        )
        
        let output = movieHomeViewModel.transform(input)
        
        output.nowPlaying
            .subscribe(with: self, onNext: { owner, movies in
                owner.applySnapshot(movies, to: \.nowPlayDataSource)
            })
            .disposed(by: disposeBag)
        
        output.popular
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, movies in
                owner.applySnapshot(movies, to: \.popularDataSource)
            })
            .disposed(by: disposeBag)
        
        output.topRated
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, movies in
                owner.applySnapshot(movies, to: \.topRatedDataSource)
            })
            .disposed(by: disposeBag)
        
        movieHomeView.nowPlayCollectionView.rx.itemSelected
            .withUnretained(self)
            .map { $0.nowPlayDataSource?.itemIdentifier(for: $1) }
            .compactMap { $0?.id }
            .subscribe(with: self, onNext: {
                $0.route(id: $1)
            })
            .disposed(by: disposeBag)
        
        movieHomeView.popularCollectionView.rx.itemSelected
            .withUnretained(self)
            .map { $0.popularDataSource?.itemIdentifier(for: $1) }
            .compactMap { $0?.id }
            .subscribe(with: self, onNext: {
                $0.route(id: $1)
            })
            .disposed(by: disposeBag)
        
        movieHomeView.topRatedCollectionView.rx.itemSelected
            .withUnretained(self)
            .map { $0.topRatedDataSource?.itemIdentifier(for: $1) }
            .compactMap { $0?.id }
            .subscribe(with: self, onNext: {
                $0.route(id: $1)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func route(id: Int) {
        let movieDetail = MovieDetailViewController(
            view: MovieDetailView(),
            viewModel: MovieDetailViewModel(
                networkManager: DefaultNetworkManager.shared,
                id: id
            )
        )
        self.navigationController?.pushViewController(movieDetail, animated: true)
    }
    
}

// MARK: - DiffableDataSource

private extension MovieHomeViewController {
    
    func applySnapshot(
        _ movies: [Movie],
        to keyPath: ReferenceWritableKeyPath<MovieHomeViewController, UICollectionViewDiffableDataSource<Int, Movie>?>
    ) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
            snapshot.appendSections([0])
            snapshot.appendItems(movies)
            self[keyPath: keyPath]?.apply(snapshot)
        }
    }
    
    func configureDataSource() {
        
        let bigImageCell = UICollectionView.CellRegistration<RoundImageCell, Movie> {
            $0.setup($2.posterPath(size: .big))
        }
        
        let smallImageCell = UICollectionView.CellRegistration<RoundImageCell, Movie> {
            $0.setup($2.posterPath(size: .small))
        }
        
        nowPlayDataSource = UICollectionViewDiffableDataSource<Int, Movie>(
            collectionView: movieHomeView.nowPlayCollectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: bigImageCell,
                    for: indexPath,
                    item: item
                )
            }
        )
        
        popularDataSource = UICollectionViewDiffableDataSource<Int, Movie>(
            collectionView: movieHomeView.popularCollectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: smallImageCell,
                    for: indexPath,
                    item: item
                )
            }
        )
        
        topRatedDataSource = UICollectionViewDiffableDataSource<Int, Movie>(
            collectionView: movieHomeView.topRatedCollectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: smallImageCell,
                    for: indexPath,
                    item: item
                )
            }
        )
    }
    
    func configureSupplementaryView() {
        
        let popular = UICollectionView.SupplementaryRegistration<TitleView>.registration(
            elementKind: ElementKind.sectionHeader,
            title: String(localized: "Popular Movies")
        )

        popularDataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if case ElementKind.sectionHeader = elementKind {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: popular,
                    for: indexPath
                )
            }
            fatalError("\(elementKind) not handled!!")
        }
        
        let topRated = UICollectionView.SupplementaryRegistration<TitleView>.registration(
            elementKind: ElementKind.sectionHeader,
            title: String(localized: "Top Rated Movies")
        )
        
        topRatedDataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if case ElementKind.sectionHeader = elementKind {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: topRated,
                    for: indexPath
                )
            }
            fatalError("\(elementKind) not handled!!")
        }
    }
    
}
