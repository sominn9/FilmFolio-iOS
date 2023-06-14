//
//  HomeViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/05/09.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var stackView = UIStackView()
    
    // MARK: Now Playing
    
    private lazy var nowPlayingCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.carousel()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: Layout.padding, bottom: 0, right: 0)
        return collectionView
    }()
    
    private var nowPlayingDataSource: UICollectionViewDiffableDataSource<Int, Movie.ID>?
    
    // MARK: Popular
    
    private lazy var popularCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.grid()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private var popularDataSource: UICollectionViewDiffableDataSource<Int, Movie.ID>?
    
    // MARK: Top Rated
    
    private lazy var topRatedCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.grid()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private var topRatedDataSource: UICollectionViewDiffableDataSource<Int, Movie.ID>?
    
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
        
        viewModel.requestNowPlayMovies { [unowned self] movies in
            var snapshot = NSDiffableDataSourceSnapshot<Int, Movie.ID>()
            snapshot.appendSections([0])
            snapshot.appendItems(self.viewModel.nowPlaying.array.map { $0.id })
            self.nowPlayingDataSource?.apply(snapshot)
        }
        
        viewModel.requestPopularMovies { [unowned self] movies in
            var snapshot = NSDiffableDataSourceSnapshot<Int, Movie.ID>()
            snapshot.appendSections([0])
            snapshot.appendItems(self.viewModel.popular.array.map { $0.id })
            self.popularDataSource?.apply(snapshot)
        }
        
        viewModel.requestTopRatedMovies { [unowned self] movies in
            var snapshot = NSDiffableDataSourceSnapshot<Int, Movie.ID>()
            snapshot.appendSections([0])
            snapshot.appendItems(self.viewModel.topRated.array.map { $0.id })
            self.topRatedDataSource?.apply(snapshot)
        }
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

// MARK: - Now Playing

private extension HomeViewController {
    
    func configureNowPlayingCollectionView() {
        stackView.addArrangedSubview(nowPlayingCollectionView)
        NSLayoutConstraint.activate([
            nowPlayingCollectionView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            nowPlayingCollectionView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            nowPlayingCollectionView.bottomAnchor.constraint(equalTo: stackView.centerYAnchor, constant: -50)
        ])
    }
    
    func configureNowPlayingDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CardCell, Movie> { cell, indexPath, movie in
            cell.setup(movie.fullPosterPath)
        }
        
        nowPlayingDataSource = UICollectionViewDiffableDataSource(collectionView: nowPlayingCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let movie = self.viewModel.nowPlaying.find(by: itemIdentifier)
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        })
    }
}

// MARK: - Popular

private extension HomeViewController {
    
    func configurePopularCollectionView() {
        stackView.addArrangedSubview(popularCollectionView)
        NSLayoutConstraint.activate([
            popularCollectionView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            popularCollectionView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            popularCollectionView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    func configurePopularDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CardCell, Movie> { cell, indexPath, movie in
            cell.setup(movie.fullPosterPath)
        }
        
        popularDataSource = UICollectionViewDiffableDataSource(collectionView: popularCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let movie = self.viewModel.popular.find(by: itemIdentifier)
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        })
    }
}

// MARK: - Top Rated

private extension HomeViewController {
    
    func configureTopRatedCollectionView() {
        stackView.addArrangedSubview(topRatedCollectionView)
        NSLayoutConstraint.activate([
            topRatedCollectionView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            topRatedCollectionView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            topRatedCollectionView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    func configureTopRatedDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CardCell, Movie> { cell, indexPath, movie in
            cell.setup(movie.fullPosterPath)
        }
        
        topRatedDataSource = UICollectionViewDiffableDataSource(collectionView: topRatedCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let movie = self.viewModel.topRated.find(by: itemIdentifier)
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        })
    }
}
