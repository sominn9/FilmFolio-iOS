//
//  MovieDetailViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/16.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class MovieDetailViewController: BaseViewController {
    
    enum Item: Hashable {
        case similar(Movie)
        // case video([Video])
    }
    
    struct Section: Hashable {
        let title: String?
    }
    
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let movieDetailView: MovieDetailView
    private let movieDetailViewModel: MovieDetailViewModel
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    
    // MARK: Initializing
    
    init(view: MovieDetailView, viewModel: MovieDetailViewModel) {
        self.movieDetailView = view
        self.movieDetailViewModel = viewModel
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
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil")
        )
    }
    
    private func configure() {
        self.view.addSubview(movieDetailView)
        movieDetailView.snp.makeConstraints {
            $0.edges.equalTo(self.view.snp.edges)
        }

        configureDiffableDataSource()
    }
    
    private func bind() {
        
        guard let barButton = navigationItem.rightBarButtonItem else { return }
        
        let input = MovieDetailViewModel.Input(
            fetchMovieDetail: Observable.just(()),
            reviewButtonPressed: barButton.rx.tap.asObservable()
        )
        
        let output = movieDetailViewModel.transform(input)
        
        output.movieDetail
            .map { $0.backdropPath }
            .subscribe(with: self, onNext: {
                $0.movieDetailView.setup($1)
            })
            .disposed(by: disposeBag)
        
        output.movieDetail
            .map { $0.title }
            .bind(to: movieDetailView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.movieDetail
            .map { $0.overview.withLineHeightMultiple(1.25) }
            .bind(to: movieDetailView.overviewLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        output.movieDetail
            .map { "\(String(localized: "Release"))  \($0.releaseDate)" }
            .map { $0.withBold(target: String(localized: "Release"), UIColor.darkGray) }
            .bind(to: movieDetailView.releaseDateLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        output.movieDetail
            .map { $0.genre }
            .bind(to: movieDetailView.genreLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.similarMovies
            .subscribe(with: self) { owner, movies in
                DispatchQueue.main.async {
                    if var snapshot = owner.diffableDataSource?.snapshot() {
                        let items = movies.map { MovieDetailViewController.Item.similar($0) }
                        snapshot.appendItems(items, toSection: .init(title: "Similar"))
                        owner.diffableDataSource?.apply(snapshot)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.loadedReview
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, review in
                let vm = ReviewViewModel(review: review)
                let vc = ReviewViewController(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

    }
    
    private func configureDiffableDataSource() {
        let cell = UICollectionView.CellRegistration<RoundImageCell, Movie> { cell, indexPath, movie in
            cell.setup(movie.posterPath(size: .small))
        }
        
        let header = UICollectionView.SupplementaryRegistration<TitleView>(elementKind: ElementKind.sectionHeader) {
            [weak self] titleView, _, indexPath in
            let section = self?.diffableDataSource?.sectionIdentifier(for: indexPath.row)
            titleView.titleLabel.text = section?.title
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(
            collectionView: movieDetailView.collectionView,
            cellProvider: { collectionView, indexPath, item in
                switch item {
                case let .similar(movie):
                    return collectionView.dequeueConfiguredReusableCell(
                        using: cell,
                        for: indexPath,
                        item: movie
                    )
                }
            }
        )
        
        diffableDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.init(title: "Similar")])
        snapshot.appendItems([], toSection: .init(title: "Similar"))
        diffableDataSource?.apply(snapshot)
    }
    
}
