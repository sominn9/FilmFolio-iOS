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
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let seriesDetailView: SeriesDetailView
    private let seriesDetailViewModel: SeriesDetailViewModel
    
    
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
        
        let editAction = UIAction { [weak self] _ in
            let vc = ReviewViewController(viewModel: ReviewViewModel())
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            primaryAction: editAction
        )
    }
    
    private func bind() {
        
        let input = SeriesDetailViewModel.Input(fetchSeriesDetail: Observable.just(()))
        
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
        
        output.seriesDetail
            .map { "\(String(localized: "Episodes"))  \($0.numberOfEpisodes)"}
            .map { $0.withBold(target: String(localized: "Episodes"), UIColor.darkGray) }
            .bind(to: seriesDetailView.numberOfEpisodesLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        output.seriesDetail
            .map { $0.genre }
            .bind(to: seriesDetailView.genreLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
}
