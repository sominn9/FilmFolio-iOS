//
//  ReviewListViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/31.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ReviewListViewController: BaseViewController {
    
    // MARK: Properties
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: .list(spacing: 10, estimatedHeight: 100))
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    @Inject private var reviewListViewModel: ReviewListViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, Review>?
    private let fetchReviews = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init() {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchReviews.onNext(())
    }
    
    
    // MARK: Methods
    
    private func configure() {
        configureTableView()
        configureNavigationTitle()
        configureDataSource()
    }
    
    private func configureTableView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges).inset(16.0)
        }
    }
    
    private func configureNavigationTitle() {
        let button = UIButton(configuration: .titleMenu(
            String(localized: "Review"),
            fontSize: 19,
            showChevron: false
        ))
        button.isUserInteractionEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func bind() {
        let input = ReviewListViewModel.Input(fetchReviews: fetchReviews.asObservable())
        let output = reviewListViewModel.transform(input)
        
        output.reviewList
            .subscribe(with: self) { owner, reviews in
                owner.applySnapshot(reviews)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                guard let review = owner.dataSource?.itemIdentifier(for: indexPath) else { return }
                let vc: ReviewViewController = DIContainer.shared.resolve(argument: review)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() {
        let cell = UICollectionView.CellRegistration<ReviewListCell, Review> { cell, indexPath, review in
            cell.setup(review)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Review>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, review in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cell,
                    for: indexPath,
                    item: review
                )
            }
        )
        
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Int, Review>()
            snapshot.appendSections([0])
            self.dataSource?.apply(snapshot)
        }
    }
    
    private func applySnapshot(_ newReviews: [Review]) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Int, Review>()
            snapshot.appendSections([0])
            snapshot.appendItems(newReviews)
            self.dataSource?.apply(snapshot)
        }
    }
    
}
