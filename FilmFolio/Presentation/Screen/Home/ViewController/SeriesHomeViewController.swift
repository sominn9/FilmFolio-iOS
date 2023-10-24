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
    
    enum Section: Int, CustomStringConvertible, CaseIterable {
        case trending
        case onTheAir
        case topRated
        
        var description: String {
            switch self {
            case .trending:  return ""
            case .onTheAir:  return String(localized: "On The Air Series")
            case .topRated:  return String(localized: "Top Rated Series")
            }
        }
    }
    
    enum Item: Hashable {
        case trending(Series)
        case onTheAir(Series)
        case topRated(Series)
    }
    
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let seriesHomeView: SeriesHomeView
    private let seriesHomeViewModel: SeriesHomeViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    
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
    
    private func configure() {
        view.addSubview(seriesHomeView)
        seriesHomeView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        configureDataSource()
        configureSupplementaryView()
    }
    
    private func bind() {
        
        let input = SeriesHomeViewModel.Input(fetchSeries: Observable.just(()))
        
        let output = seriesHomeViewModel.transform(input)
        
        output.trending
            .subscribe(with: self, onNext: { owner, series in
                let items = series.map { Item.trending($0) }
                owner.applySnapshot(items, .trending)
            })
            .disposed(by: disposeBag)
        
        output.onTheAir
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, series in
                let items = series.map { Item.onTheAir($0) }
                owner.applySnapshot(items, .onTheAir)
            })
            .disposed(by: disposeBag)
        
        output.topRated
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, series in
                let items = series.map { Item.topRated($0) }
                owner.applySnapshot(items, .topRated)
            })
            .disposed(by: disposeBag)
        
        seriesHomeView.collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { $0.dataSource?.itemIdentifier(for: $1) }
            .subscribe(with: self, onNext: {
                var id: Int? = nil
                
                switch $1 {
                case let .trending(series): id = series.id
                case let .onTheAir(series): id = series.id
                case let .topRated(series): id = series.id
                }
                
                guard let id else { return }
                let view = SeriesDetailView()
                let vm = SeriesDetailViewModel(id: id)
                let vc = SeriesDetailViewController(view: view, viewModel: vm)
                $0.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
}

// MARK: - DiffableDataSource

private extension SeriesHomeViewController {
    
    func applySnapshot(_ items: [Item], _ section: Section) {
        DispatchQueue.main.async {
            if var snapshot = self.dataSource?.snapshot(for: section) {
                snapshot.append(items)
                self.dataSource?.apply(snapshot, to: section)
            }
        }
    }
    
    func configureDataSource() {
        let cellType1 = UICollectionView.CellRegistration<RoundImageCell, Item> { cell, _, item in
            if case let .trending(series) = item {
                cell.setup(series.posterPath(size: .big))
            }
        }
        
        let cellType2 = UICollectionView.CellRegistration<RoundImageCell, Item> { cell, _, item in
            if case let .onTheAir(series) = item {
                cell.setup(series.posterPath(size: .small))
            } else if case let .topRated(series) = item {
                cell.setup(series.posterPath(size: .small))
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: seriesHomeView.collectionView,
            cellProvider: { collectionView, indexPath, item in
                if indexPath.section == 0 {
                    return collectionView.dequeueConfiguredReusableCell(
                        using: cellType1,
                        for: indexPath,
                        item: item
                    )
                } else {
                    return collectionView.dequeueConfiguredReusableCell(
                        using: cellType2,
                        for: indexPath,
                        item: item
                    )
                }
            }
        )
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        self.dataSource?.apply(snapshot)
    }
    
    func configureSupplementaryView() {
        let onTheAirSectionHeader = UICollectionView.SupplementaryRegistration<TitleView>.registration(
            elementKind: ElementKind.sectionHeader.rawValue,
            title: Section.onTheAir.description
        )
        
        let topRatedSectionHeader = UICollectionView.SupplementaryRegistration<TitleView>.registration(
            elementKind: ElementKind.sectionHeader.rawValue,
            title: Section.topRated.description
        )
        
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if let section = Section(rawValue: indexPath.section) {
                switch section {
                case .onTheAir:
                    return collectionView.dequeueConfiguredReusableSupplementary(
                        using: onTheAirSectionHeader,
                        for: indexPath
                    )
                case .topRated:
                    return collectionView.dequeueConfiguredReusableSupplementary(
                        using: topRatedSectionHeader,
                        for: indexPath
                    )
                default:
                    break
                }
            }
            
            return nil
        }
    }
    
}
