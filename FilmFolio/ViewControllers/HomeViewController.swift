//
//  HomeViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/05/09.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    // MARK: Properties
    
    private let homeView: HomeView
    private let homeViewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    private var nowPlayDataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    private var popularDataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    private var topRatedDataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    
    
    // MARK: Initializing
    
    init(view: HomeView, viewModel: HomeViewModel) {
        self.homeView = view
        self.homeViewModel = viewModel
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
    
    func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(homeView)
        homeView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        configureNavigationBar()
        configureDataSource()
        configureSupplementaryView()
    }
    
    func configureNavigationBar() {
        self.title = "영화"
    }
    
    func bind() {
        
        let input = HomeViewModel.Input(
            fetchNowPlayMovies: Observable.just(()),
            fetchPopularMovies: Observable.just(()),
            fetchTopRatedMovies: Observable.just(())
        )
        
        let output = homeViewModel.transform(input)
        
        output.nowPlaying
            .subscribe(with: self, onNext: { owner, movies in
                owner.applySnapshot(movies, to: \.nowPlayDataSource)
            })
            .disposed(by: disposeBag)
        
        output.popular
            .subscribe(with: self, onNext: { owner, movies in
                owner.applySnapshot(movies, to: \.popularDataSource)
            })
            .disposed(by: disposeBag)
        
        output.topRated
            .subscribe(with: self, onNext: { owner, movies in
                owner.applySnapshot(movies, to: \.topRatedDataSource)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - DiffableDataSource

private extension HomeViewController {
    
    func applySnapshot(
        _ movies: [Movie],
        to keyPath: ReferenceWritableKeyPath<HomeViewController, UICollectionViewDiffableDataSource<Int, Movie>?>
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(movies)
        self[keyPath: keyPath]?.apply(snapshot)
    }
    
    func configureDataSource() {
        
        nowPlayDataSource = UICollectionViewDiffableDataSource<Int, Movie>(
            collectionView: homeView.nowPlayCollectionView,
            cellProvider: UICollectionViewDiffableDataSource<Int, Movie>.cellProvider(
                using: UICollectionView.CellRegistration<RoundImageCell, Movie>(handler: { cell, _, movie in
                    cell.setup(movie.posterPath(size: .big))
                })
            )
        )
        
        popularDataSource = UICollectionViewDiffableDataSource<Int, Movie>(
            collectionView: homeView.popularCollectionView,
            cellProvider: UICollectionViewDiffableDataSource<Int, Movie>.cellProvider(
                using: UICollectionView.CellRegistration<RoundImageCell, Movie>(handler: { cell, _, movie in
                    cell.setup(movie.posterPath(size: .small))
                })
            )
        )
        
        topRatedDataSource = UICollectionViewDiffableDataSource<Int, Movie>(
            collectionView: homeView.topRatedCollectionView,
            cellProvider: UICollectionViewDiffableDataSource<Int, Movie>.cellProvider(
                using: UICollectionView.CellRegistration<RoundImageCell, Movie>(handler: { cell, _, movie in
                    cell.setup(movie.posterPath(size: .small))
                })
            )
        )
    }
    
    func configureSupplementaryView() {
        
        let popular = UICollectionView.SupplementaryRegistration<TitleView>.registration(
            elementKind: ElementKind.sectionHeader,
            title: "인기 영화"
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
            title: "높은 평점의 인기 영화"
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
