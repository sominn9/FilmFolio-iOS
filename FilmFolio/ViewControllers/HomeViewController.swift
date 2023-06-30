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
    
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(homeView)
        homeView.snp.makeConstraints({ $0.edges.equalTo(view )})
        configureDataSource()
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
        
        let cellRegistration = UICollectionView.CellRegistration<RoundImageCell, Movie> { roundImageCell, indexPath, movie in
            roundImageCell.setup(movie.fullPosterPath)
        }
        
        let cellProvider: UICollectionViewDiffableDataSource<Int, Movie>.CellProvider = { collectionView, indexPath, movie in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: movie
            )
        }
        
        nowPlayDataSource = UICollectionViewDiffableDataSource<Int, Movie>(
            collectionView: homeView.nowPlayCollectionView,
            cellProvider: cellProvider
        )
        
        popularDataSource = UICollectionViewDiffableDataSource<Int, Movie>(
            collectionView: homeView.popularCollectionView,
            cellProvider: cellProvider
        )
        
        topRatedDataSource = UICollectionViewDiffableDataSource<Int, Movie>(
            collectionView: homeView.topRatedCollectionView,
            cellProvider: cellProvider
        )
    }
    
}
