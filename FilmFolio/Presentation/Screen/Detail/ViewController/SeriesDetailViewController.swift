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

enum SeriesDetailSection: CaseIterable, CustomStringConvertible {
    case similar
    
    var description: String {
        switch self {
        case .similar: return "Similar"
        }
    }
}

final class SeriesDetailViewController: BaseViewController {
    
    enum Item: Hashable {
        case similar(Series)
    }
    
    
    // MARK: Properties
    
    @Inject private var seriesDetailView: SeriesDetailView
    @Inject private var seriesDetailViewModel: SeriesDetailViewModel
    private var diffableDataSource: UICollectionViewDiffableDataSource<SeriesDetailSection, Item>?
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(id: Int) {
        self._seriesDetailViewModel = Inject(argument: id)
        super.init(nibName: nil, bundle: nil)
        self.seriesDetailView.indexToSection = { [weak self] index in
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
        
        let input = SeriesDetailViewModel.Input(
            fetchSeriesDetail: Observable.just(()),
            reviewButtonPressed: barButton.rx.tap.asObservable()
        )
        
        let output = seriesDetailViewModel.transform(input)
        
        output.seriesDetail
            .map { $0.backdropURL }
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
                let items = series.map { SeriesDetailViewController.Item.similar($0) }
                owner.applySnapshot(items, to: .similar)
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
                let vc: ReviewViewController = DIContainer.shared.resolve(argument: review)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        seriesDetailView.collectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                if let model = owner.diffableDataSource?.itemIdentifier(for: indexPath) {
                    switch model {
                    case let .similar(series):
                        let vc: SeriesDetailViewController = DIContainer.shared.resolve(argument: series.id)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func layout() {
        self.view.addSubview(seriesDetailView)
        seriesDetailView.snp.makeConstraints {
            $0.edges.equalTo(self.view.snp.edges)
        }
    }
    
}

// MARK: - DiffableDataSource

private extension SeriesDetailViewController {
    
    func applySnapshot(_ items: [Item], to section: SeriesDetailSection) {
        DispatchQueue.main.async {
            guard var snapshot = self.diffableDataSource?.snapshot() else { return }
            snapshot.appendItems(items, toSection: section)
            self.diffableDataSource?.apply(snapshot, completion: { [weak self] in
                self?.seriesDetailView.updateCollectionViewHeight()
            })
        }
    }
    
    func configureDiffableDataSource() {
        let series = UICollectionView.CellRegistration<RoundImageCell, Series> { cell, indexPath, series in
            cell.setup(series.posterURL(size: .small))
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(
            collectionView: seriesDetailView.collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                if let section = self?.diffableDataSource?.sectionIdentifier(for: indexPath.section) {
                    switch section {
                    case .similar:
                        if case let .similar(data) = item {
                            return collectionView.dequeueConfiguredReusableCell(
                                using: series,
                                for: indexPath,
                                item: data
                            )
                        }
                    }
                }
                
                return nil
            }
        )
        
        var snapshot = NSDiffableDataSourceSnapshot<SeriesDetailSection, Item>()
        snapshot.appendSections(SeriesDetailSection.allCases)
        diffableDataSource?.apply(snapshot)
    }
    
    func configureSupplementaryView() {
        let header = UICollectionView.SupplementaryRegistration<TitleView>(elementKind: ElementKind.sectionHeader.rawValue) {
            [weak self] titleView, _, indexPath in
            let section = self?.diffableDataSource?.sectionIdentifier(for: indexPath.section)
            titleView.titleLabel.text = section?.description
        }
        
        diffableDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if let kind = ElementKind(rawValue: kind) {
                switch kind {
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
