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
    
    private let viewModel: HomeViewModel
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var stackView = UIStackView()
    
    private let disposeBag = DisposeBag()
    
    // MARK: Now Playing
    
    private lazy var nowPlayingCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.carousel()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: Layout.padding, bottom: 0, right: 0)
        return collectionView
    }()
    
    private var nowPlayingDataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    
    // MARK: Popular
    
    private lazy var popularCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.grid()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private var popularDataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    
    // MARK: Top Rated
    
    private lazy var topRatedCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.grid()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private var topRatedDataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    
    // MARK: - Inits
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    func configure() {
        view.backgroundColor = .white
        configureScrollView()
        
        configureNowPlayingCollectionView()
        configureNowPlayingDataSource()
        
        configurePopularCollectionView()
        configurePopularDataSource()
        
        configureTopRatedCollectionView()
        configureTopRatedDataSource()
    }
    
    func bind() {
        let input = HomeViewModel.Input(
            fetchNowPlayMovies: Observable.just(()),
            fetchPopularMovies: Observable.just(()),
            fetchTopRatedMovies: Observable.just(())
        )
        
        let output = viewModel.transform(input)
        
        output.nowPlaying
            .subscribe(onNext: {
                var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
                snapshot.appendSections([0])
                snapshot.appendItems($0)
                self.nowPlayingDataSource?.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        output.popular
            .subscribe(onNext: {
                var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
                snapshot.appendSections([0])
                snapshot.appendItems($0)
                self.popularDataSource?.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        output.topRated
            .subscribe(onNext: {
                var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
                snapshot.appendSections([0])
                snapshot.appendItems($0)
                self.topRatedDataSource?.apply(snapshot)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Layout.padding
        
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

// MARK: - Diffable DataSource

private extension HomeViewController {
    
    func configureNowPlayingCollectionView() {
        stackView.addArrangedSubview(nowPlayingCollectionView)
        NSLayoutConstraint.activate([
            nowPlayingCollectionView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            nowPlayingCollectionView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            nowPlayingCollectionView.bottomAnchor.constraint(equalTo: stackView.centerYAnchor, constant: -50)
        ])
    }
    
    func configurePopularCollectionView() {
        stackView.addArrangedSubview(popularCollectionView)
        NSLayoutConstraint.activate([
            popularCollectionView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            popularCollectionView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            popularCollectionView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    func configureTopRatedCollectionView() {
        stackView.addArrangedSubview(topRatedCollectionView)
        NSLayoutConstraint.activate([
            topRatedCollectionView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            topRatedCollectionView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            topRatedCollectionView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    func configureNowPlayingDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RoundImageCell, Movie> { cell, indexPath, movie in
            cell.setup(movie.fullPosterPath)
        }
        
        nowPlayingDataSource = UICollectionViewDiffableDataSource(collectionView: nowPlayingCollectionView, cellProvider: { collectionView, indexPath, movie in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        })
    }
    
    func configurePopularDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RoundImageCell, Movie> { cell, indexPath, movie in
            cell.setup(movie.fullPosterPath)
        }
        
        popularDataSource = UICollectionViewDiffableDataSource(collectionView: popularCollectionView, cellProvider: { collectionView, indexPath, movie in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        })
    }
    
    func configureTopRatedDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RoundImageCell, Movie> { cell, indexPath, movie in
            cell.setup(movie.fullPosterPath)
        }
        
        topRatedDataSource = UICollectionViewDiffableDataSource(collectionView: topRatedCollectionView, cellProvider: { collectionView, indexPath, movie in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        })
    }
}
