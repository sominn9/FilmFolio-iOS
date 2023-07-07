//
//  SeriesHomeViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/06.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SeriesHomeViewController: UIViewController {
    
    // MARK: Properties
    
    private let seriesHomeView: SeriesHomeView
    private let seriesHomeViewModel: SeriesHomeViewModel
    private let disposeBag = DisposeBag()
    private var trendingDataSource: UICollectionViewDiffableDataSource<Int, Series>?
    private var onTheAirDataSource: UICollectionViewDiffableDataSource<Int, Series>?
    private var topRatedDataSource: UICollectionViewDiffableDataSource<Int, Series>?
    
    
    // MARK: Initializing
    
    init(view: SeriesHomeView, viewModel: SeriesHomeViewModel) {
        self.seriesHomeView = view
        self.seriesHomeViewModel = viewModel
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
        view.addSubview(seriesHomeView)
        seriesHomeView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        configureDataSource()
        configureSupplementaryView()
    }
    
    func bind() {
        
        let input = SeriesHomeViewModel.Input(
            fetchTrendingSeries: Observable.just(()),
            fetchOnTheAirSeries: Observable.just(()),
            fetchTopRatedSeries: Observable.just(())
        )
        
        let output = seriesHomeViewModel.transform(input)
        
        output.trending
            .subscribe(with: self, onNext: { owner, series in
                owner.applySnapshot(series, to: \.trendingDataSource)
            })
            .disposed(by: disposeBag)
        
        output.onTheAir
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, series in
                owner.applySnapshot(series, to: \.onTheAirDataSource)
            })
            .disposed(by: disposeBag)
        
        output.topRated
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, series in
                owner.applySnapshot(series, to: \.topRatedDataSource)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - DiffableDataSource

private extension SeriesHomeViewController {
    
    func applySnapshot(
        _ series: [Series],
        to keyPath: ReferenceWritableKeyPath<SeriesHomeViewController, UICollectionViewDiffableDataSource<Int, Series>?>
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Series>()
        snapshot.appendSections([0])
        snapshot.appendItems(series)
        self[keyPath: keyPath]?.apply(snapshot)
    }
    
    func configureDataSource() {
        
        trendingDataSource = UICollectionViewDiffableDataSource<Int, Series>(
            collectionView: seriesHomeView.trendingCollectionView,
            cellProvider: UICollectionViewDiffableDataSource<Int, Series>.cellProvider(
                using: UICollectionView.CellRegistration<RoundImageCell, Series>(handler: { cell, _, series in
                    cell.setup(series.posterPath(size: .big))
                })
            )
        )
        
        onTheAirDataSource = UICollectionViewDiffableDataSource<Int, Series>(
            collectionView: seriesHomeView.onTheAirCollectionView,
            cellProvider: UICollectionViewDiffableDataSource<Int, Series>.cellProvider(
                using: UICollectionView.CellRegistration<RoundImageCell, Series>(handler: { cell, _, series in
                    cell.setup(series.posterPath(size: .small))
                })
            )
        )
        
        topRatedDataSource = UICollectionViewDiffableDataSource<Int, Series>(
            collectionView: seriesHomeView.topRatedCollectionView,
            cellProvider: UICollectionViewDiffableDataSource<Int, Series>.cellProvider(
                using: UICollectionView.CellRegistration<RoundImageCell, Series>(handler: { cell, _, series in
                    cell.setup(series.posterPath(size: .small))
                })
            )
        )
    }
    
    func configureSupplementaryView() {
        
        let onTheAir = UICollectionView.SupplementaryRegistration<TitleView>.registration(
            elementKind: ElementKind.sectionHeader,
            title: String(localized: "On The Air Series")
        )

        onTheAirDataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if case ElementKind.sectionHeader = elementKind {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: onTheAir,
                    for: indexPath
                )
            }
            fatalError("\(elementKind) not handled!!")
        }
        
        let topRated = UICollectionView.SupplementaryRegistration<TitleView>.registration(
            elementKind: ElementKind.sectionHeader,
            title: String(localized: "Top Rated Series")
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
