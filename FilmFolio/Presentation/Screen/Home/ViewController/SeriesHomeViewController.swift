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

enum SeriesHomeSection: CustomStringConvertible, CaseIterable {
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

final class SeriesHomeViewController: UIViewController {
    
    enum Item: Hashable {
        case trending(Series)
        case onTheAir(Series)
        case topRated(Series)
    }
    
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let seriesHomeView: SeriesHomeView
    private let seriesHomeViewModel: SeriesHomeViewModel
    private var dataSource: UICollectionViewDiffableDataSource<SeriesHomeSection, Item>?
    
    
    // MARK: Initializing
    
    init(view: SeriesHomeView, viewModel: SeriesHomeViewModel) {
        self.seriesHomeView = view
        self.seriesHomeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.seriesHomeView.indexToSection = { [weak self] index in
            return self?.dataSource?.sectionIdentifier(for: index)
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
    
    private func configure() {
        layout()
        configureDataSource()
        configureSupplementaryView()
    }
    
    private func bind() {
        let input = SeriesHomeViewModel.Input(fetchSeries: Observable.just(()))
        
        let output = seriesHomeViewModel.transform(input)
        
        output.trending
            .subscribe(with: self, onNext: { owner, series in
                let items = series.map { Item.trending($0) }
                owner.applySnapshot(items, SeriesHomeSection.trending)
            })
            .disposed(by: disposeBag)
        
        output.onTheAir
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, series in
                let items = series.map { Item.onTheAir($0) }
                owner.applySnapshot(items, SeriesHomeSection.onTheAir)
            })
            .disposed(by: disposeBag)
        
        output.topRated
            .map { $0.count > 6 ? Array($0[0..<6]) : $0 }
            .subscribe(with: self, onNext: { owner, series in
                let items = series.map { Item.topRated($0) }
                owner.applySnapshot(items, SeriesHomeSection.topRated)
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
    
    private func layout() {
        view.addSubview(seriesHomeView)
        seriesHomeView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }
    
}

// MARK: - DiffableDataSource

private extension SeriesHomeViewController {
    
    func applySnapshot(_ items: [Item], _ section: SeriesHomeSection) {
        DispatchQueue.main.async {
            guard var snapshot = self.dataSource?.snapshot() else { return }
            snapshot.appendItems(items, toSection: section)
            self.dataSource?.apply(snapshot)
        }
    }
    
    func configureDataSource() {
        let cellType1 = UICollectionView.CellRegistration<RoundImageCell, Item> { cell, _, item in
            if case let .trending(series) = item {
                cell.setup(series.posterURL(size: .big))
            }
        }
        
        let cellType2 = UICollectionView.CellRegistration<RoundImageCell, Item> { cell, _, item in
            if case let .onTheAir(series) = item {
                cell.setup(series.posterURL(size: .small))
            } else if case let .topRated(series) = item {
                cell.setup(series.posterURL(size: .small))
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<SeriesHomeSection, Item>(
            collectionView: seriesHomeView.collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                if let section = self?.dataSource?.sectionIdentifier(for: indexPath.section) {
                    switch section {
                    case .trending:
                        return collectionView.dequeueConfiguredReusableCell(
                            using: cellType1,
                            for: indexPath,
                            item: item
                        )
                    case .onTheAir, .topRated:
                        return collectionView.dequeueConfiguredReusableCell(
                            using: cellType2,
                            for: indexPath,
                            item: item
                        )
                    }
                }
                
                return nil
            }
        )
        
        var snapshot = NSDiffableDataSourceSnapshot<SeriesHomeSection, Item>()
        snapshot.appendSections(SeriesHomeSection.allCases)
        self.dataSource?.apply(snapshot)
    }
    
    func configureSupplementaryView() {
        let header = UICollectionView.SupplementaryRegistration<TitleView>(elementKind: ElementKind.sectionHeader.rawValue) {
            [weak self] titleView, elementKind, indexPath in
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            titleView.titleLabel.text = section?.description
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if let elementKind = ElementKind(rawValue: elementKind) {
                switch elementKind {
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
