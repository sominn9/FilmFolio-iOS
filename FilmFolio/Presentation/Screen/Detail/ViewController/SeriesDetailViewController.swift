//
//  SeriesDetailViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/17.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SeriesDetailViewController: BaseViewController {
    
    enum Section: Int, Hashable, CustomStringConvertible {
        case similar
        
        var description: String {
            switch self {
            case .similar: return "Similar"
            }
        }
    }
    
    enum Item: Hashable {
        case similar(Series)
    }
    
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let seriesDetailView: SeriesDetailView
    private let seriesDetailViewModel: SeriesDetailViewModel
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    
    // MARK: Initializing
    
    init(view: SeriesDetailView, viewModel: SeriesDetailViewModel) {
        self.seriesDetailView = view
        self.seriesDetailViewModel = viewModel
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
        self.view.addSubview(seriesDetailView)
        seriesDetailView.snp.makeConstraints {
            $0.edges.equalTo(self.view.snp.edges)
        }
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil")
        )
        
        configureDiffableDataSource()
    }
    
    private func bind() {
        
        guard let barButton = navigationItem.rightBarButtonItem else { return }
        
        let input = SeriesDetailViewModel.Input(
            fetchSeriesDetail: Observable.just(()),
            reviewButtonPressed: barButton.rx.tap.asObservable()
        )
        
        let output = seriesDetailViewModel.transform(input)
        
        output.seriesDetail
            .map { $0.backdropPath }
            .subscribe(with: self, onNext: {
                $0.seriesDetailView.setup($1)
            })
            .disposed(by: disposeBag)
        
        output.seriesDetail
            .map { $0.name }
            .bind(to: seriesDetailView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.seriesDetail
            .map { $0.overview.withLineHeightMultiple(1.25) }
            .bind(to: seriesDetailView.overviewLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        output.seriesDetail
            .map { "\(String(localized: "First Air"))  \($0.firstAirDate)" }
            .map { $0.withBold(target: String(localized: "First Air"), UIColor.darkGray) }
            .bind(to: seriesDetailView.firstAirDateLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        output.similarSeries
            .subscribe(with: self) { owner, series in
                DispatchQueue.main.async {
                    if var snapshot = owner.diffableDataSource?.snapshot() {
                        let items = series.map { SeriesDetailViewController.Item.similar($0) }
                        snapshot.appendItems(items, toSection: .similar)
                        owner.diffableDataSource?.apply(snapshot)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.seriesDetail
            .map { "\(String(localized: "Episodes"))  \($0.numberOfEpisodes)"}
            .map { $0.withBold(target: String(localized: "Episodes"), UIColor.darkGray) }
            .bind(to: seriesDetailView.numberOfEpisodesLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        output.seriesDetail
            .map { $0.genre }
            .bind(to: seriesDetailView.genreLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.loadedReview
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, review in
                let vm = ReviewViewModel(review: review)
                let vc = ReviewViewController(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        seriesDetailView.collectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                guard let section = Section(rawValue: indexPath.section),
                      let model = owner.diffableDataSource?.itemIdentifier(for: indexPath)
                else { return }
                
                switch section {
                case .similar:
                    if case let .similar(series) = model {
                        let view = SeriesDetailView()
                        let vm = SeriesDetailViewModel(id: series.id)
                        let vc = SeriesDetailViewController(view: view, viewModel: vm)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configureDiffableDataSource() {
        let cell = UICollectionView.CellRegistration<RoundImageCell, Series> { cell, indexPath, series in
            cell.setup(series.posterPath(size: .small))
        }
        
        let header = UICollectionView.SupplementaryRegistration<TitleView>(elementKind: ElementKind.sectionHeader) {
            [weak self] titleView, _, indexPath in
            let section = self?.diffableDataSource?.sectionIdentifier(for: indexPath.row)
            titleView.titleLabel.text = section?.description
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(
            collectionView: seriesDetailView.collectionView,
            cellProvider: { collectionView, indexPath, item in
                switch item {
                case let .similar(series):
                    return collectionView.dequeueConfiguredReusableCell(
                        using: cell,
                        for: indexPath,
                        item: series
                    )
                }
            }
        )
        
        diffableDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.similar])
        snapshot.appendItems([], toSection: .similar)
        diffableDataSource?.apply(snapshot)
    }
    
}
