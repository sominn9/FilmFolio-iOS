//
//  MovieDetailViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/16.
//

import Common
import FoundationExtension
import Resource
import RxCocoa
import RxSwift
import SnapKit
import UIKit

enum MovieDetailSection: CaseIterable, CustomStringConvertible {
    case video
    case similar
    
    var description: String {
        switch self {
        case .video: return "Video"
        case .similar: return "Similar"
        }
    }
}

final class MovieDetailViewController: BaseViewController {
    
    enum Item: Hashable {
        case video(Video)
        case similar(Movie)
    }
    
    
    // MARK: Properties
    
    @Inject private var movieDetailView: MovieDetailView
    @Inject private var movieDetailViewModel: MovieDetailViewModel
    private var diffableDataSource: UICollectionViewDiffableDataSource<MovieDetailSection, Item>?
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(id: Int) {
        self._movieDetailViewModel = Inject(argument: id)
        super.init(nibName: nil, bundle: nil)
        self.movieDetailView.indexToSection = { [weak self] index in
            return self?.diffableDataSource?.sectionIdentifier(for: index)
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
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil")
        )
    }
    
    private func configure() {
        layout()
        configureDiffableDataSource()
        configureSupplementaryView()
    }
    
    private func bind() {
        guard let barButton = navigationItem.rightBarButtonItem else { return }
        
        let input = MovieDetailViewModel.Input(
            fetchMovieDetail: Observable.just(()),
            reviewButtonPressed: barButton.rx.tap.asObservable()
        )
        
        let output = movieDetailViewModel.transform(input)
        
        output.movieDetail
            .map { $0.backdropURL }
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
        
        output.movieVideos
            .subscribe(with: self) { owner, videos in
                let items = videos.map { MovieDetailViewController.Item.video($0) }
                owner.applySnapshot(items, to: .video)
            }
            .disposed(by: disposeBag)
        
        output.similarMovies
            .subscribe(with: self) { owner, movies in
                let items = movies.map { MovieDetailViewController.Item.similar($0) }
                owner.applySnapshot(items, to: .similar)
            }
            .disposed(by: disposeBag)
        
        output.loadedReview
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, review in
                let vc: ReviewViewController = DIContainer.shared.resolve(argument: review)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        movieDetailView.collectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                if let model = owner.diffableDataSource?.itemIdentifier(for: indexPath) {
                    switch model {
                    case let .video(video):
                        let vc = WebViewController(video.videoURL)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    case let .similar(movie):
                        let vc: MovieDetailViewController = DIContainer.shared.resolve(argument: movie.id)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func layout() {
        self.view.addSubview(movieDetailView)
        movieDetailView.snp.makeConstraints {
            $0.edges.equalTo(self.view.snp.edges)
        }
    }
    
}

// MARK: - DiffableDataSource

private extension MovieDetailViewController {
    
    func applySnapshot(_ items: [Item], to section: MovieDetailSection) {
        DispatchQueue.main.async {
            guard var snapshot = self.diffableDataSource?.snapshot() else  { return }
            
            if items.isEmpty {
                if snapshot.sectionIdentifiers.contains(section) {
                    snapshot.deleteSections([section])
                }
            } else {
                if !snapshot.sectionIdentifiers.contains(section) {
                    var beforeSection: MovieDetailSection?
                    var flag = false
                    
                    for s in MovieDetailSection.allCases {
                        if s == section {
                            flag = true
                            continue
                        }
                        if flag && snapshot.sectionIdentifiers.contains(s) {
                            beforeSection = s
                            break
                        }
                    }
                    
                    if let beforeSection {
                        snapshot.insertSections([section], beforeSection: beforeSection)
                    } else {
                        snapshot.appendSections([section])
                    }
                }
                snapshot.appendItems(items, toSection: section)
            }
            
            self.diffableDataSource?.apply(snapshot, completion: { [weak self] in
                self?.movieDetailView.updateCollectionViewHeight()
            })
        }
    }
    
    func configureDiffableDataSource() {
        let video = UICollectionView.CellRegistration<RoundImageCell, Video> { cell, indexPath, video in
            cell.setup(video.thumbnailURL.absoluteString)
        }
        
        let movie = UICollectionView.CellRegistration<RoundImageCell, Movie> { cell, indexPath, movie in
            cell.setup(movie.posterURL(size: .small))
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(
            collectionView: movieDetailView.collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                if let section = self?.diffableDataSource?.sectionIdentifier(for: indexPath.section) {
                    switch section {
                    case .video:
                        if case let .video(data) = item {
                            return collectionView.dequeueConfiguredReusableCell(
                                using: video,
                                for: indexPath,
                                item: data
                            )
                        }
                    case .similar:
                        if case let .similar(data) = item {
                            return collectionView.dequeueConfiguredReusableCell(
                                using: movie,
                                for: indexPath,
                                item: data
                            )
                        }
                    }
                }
                
                return nil
            }
        )
    }
    
    func configureSupplementaryView() {
        let header = UICollectionView.SupplementaryRegistration<TitleView>(elementKind: ElementKind.sectionHeader.rawValue) { 
            [weak self] titleView, _, indexPath in
            let section = self?.diffableDataSource?.sectionIdentifier(for: indexPath.section)
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
    }
    
}
