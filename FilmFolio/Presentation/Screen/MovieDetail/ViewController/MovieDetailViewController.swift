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
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let movieDetailView: MovieDetailView
    private let movieDetailViewModel: MovieDetailViewModel
    
    
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
    
    private func configure() {
        self.view.addSubview(movieDetailView)
        movieDetailView.snp.makeConstraints {
            $0.edges.equalTo(self.view.snp.edges)
        }
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil")
        )
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
        
        output.loadedReview
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, review in
                let vm = ReviewViewModel(review: review)
                let vc = ReviewViewController(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

    }
    
}
