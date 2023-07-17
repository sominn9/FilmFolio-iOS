//
//  UpcomingViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/17.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class UpcomingViewController: BaseViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let upcomingView: UpcomingView
    private let upcomingViewModel: UpcomingViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, Upcoming>?
    
    
    // MARK: Initializing
    
    init(view: UpcomingView, viewModel: UpcomingViewModel) {
        self.upcomingView = view
        self.upcomingViewModel = viewModel
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
        configureUpcomingView()
        configureNavigationTitle()
        configureDataSource()
    }
    
    private func configureUpcomingView() {
        view.backgroundColor = .systemBackground
        view.addSubview(upcomingView)
        upcomingView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
    }
    
    private func configureNavigationTitle() {
        let button = UIButton(configuration: .titleMenu(
            String(localized: "Upcoming"),
            fontSize: 19,
            showChevron: false
        ))
        button.isUserInteractionEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func bind() {
        
        let input = UpcomingViewModel.Input(fetchUpcomings: Observable.just(()))
        
        let output = upcomingViewModel.transform(input)
        
        output.upcomings
            .subscribe(with: self, onNext: {
                $0.applySnapshot($1)
            })
            .disposed(by: disposeBag)
        
    }
    
}

// MARK: - DiffableDataSource

private extension UpcomingViewController {
 
    func applySnapshot(_ upcomings: [Upcoming]) {
        DispatchQueue.main.async {
            guard let dataSource = self.dataSource else { return }
            var snapshot = dataSource.snapshot()
            snapshot.appendItems(upcomings)
            dataSource.apply(snapshot)
        }
    }
    
    func configureDataSource() {
        let cell = UICollectionView.CellRegistration<UpcomingCell, Upcoming> { cell, indexPath, item in
            cell.setup(item.backdropPath)
            cell.titleLabel.text = item.title
            cell.releaseDateLabel.text = item.releaseDate
            cell.overviewLabel.attributedText = item.overview.withLineHeightMultiple(1.25)
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: upcomingView.collectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: item)
            }
        )
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Upcoming>()
        snapshot.appendSections([0])
        dataSource?.apply(snapshot)
    }
}
