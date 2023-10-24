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
        case video(Video)
    }
    
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case similar
        case video
        
        var description: String {
            switch self {
            case .similar: return "Similar"
            case .video: return "Video"
            }
        }
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
                let items = movies.map { MovieDetailViewController.Item.similar($0) }
                owner.applySnapshot(items, .similar)
            }
            .disposed(by: disposeBag)
        
        output.movieVideos
            .subscribe(with: self) { owner, videos in
                let items = videos.map { MovieDetailViewController.Item.video($0) }
                owner.applySnapshot(items, .video)
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

        movieDetailView.collectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                guard let section = Section(rawValue: indexPath.section),
                      let model = owner.diffableDataSource?.itemIdentifier(for: indexPath) 
                else { return }
                
                switch section {
                case .similar:
                    if case let .similar(movie) = model {
                        let view = MovieDetailView()
                        let vm = MovieDetailViewModel(id: movie.id)
                        let vc = MovieDetailViewController(view: view, viewModel: vm)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                case .video:
                    if case let .video(video) = model {
                        let vc = WebViewController(video.videoURL)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func applySnapshot(_ items: [Item], _ section: Section) {
        DispatchQueue.main.async {
            if var snapshot = self.diffableDataSource?.snapshot() {
                snapshot.appendItems(items, toSection: section)
                self.diffableDataSource?.apply(snapshot)
                self.movieDetailView.collectionView.layoutIfNeeded()
                self.movieDetailView.collectionView.snp.updateConstraints {
                    $0.height.equalTo(self.movieDetailView.collectionView.contentSize.height)
                }
            }
        }
    }
    
    private func configureDiffableDataSource() {
        let movie = UICollectionView.CellRegistration<RoundImageCell, Movie> { cell, indexPath, movie in
            cell.setup(movie.posterPath(size: .small))
        }
        
        let video = UICollectionView.CellRegistration<RoundImageCell, Video> { cell, indexPath, video in
            cell.setup(video.thumbnailURL.absoluteString)
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(
            collectionView: movieDetailView.collectionView,
            cellProvider: { collectionView, indexPath, item in
                if let section = Section(rawValue: indexPath.section) {
                    switch section {
                    case .similar:
                        if case let .similar(data) = item {
                            return collectionView.dequeueConfiguredReusableCell(
                                using: movie,
                                for: indexPath,
                                item: data
                            )
                        }
                    case .video:
                        if case let .video(data) = item {
                            return collectionView.dequeueConfiguredReusableCell(
                                using: video,
                                for: indexPath,
                                item: data
                            )
                        }
                    }
                }
                return nil
            }
        )
        
        let header = UICollectionView.SupplementaryRegistration<TitleView>(elementKind: ElementKind.sectionHeader.rawValue) { titleView, _, indexPath in
            let section = Section(rawValue: indexPath.section)
            titleView.titleLabel.text = section?.description
            titleView.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        let playBadge = UICollectionView.SupplementaryRegistration<PlayView>(elementKind: ElementKind.badge.rawValue) { playView, _, _ in
            
        }
        
        diffableDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if let kind = ElementKind(rawValue: kind) {
                switch kind {
                case .badge:
                    return collectionView.dequeueConfiguredReusableSupplementary(using: playBadge, for: indexPath)
                case .sectionHeader:
                    return collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
                default:
                    break
                }
            }
            return nil
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        diffableDataSource?.apply(snapshot)
    }
    
}
