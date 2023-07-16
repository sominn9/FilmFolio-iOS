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
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(movieDetailView)
        movieDetailView.snp.makeConstraints {
            $0.edges.equalTo(self.view.snp.edges)
        }
    }
    
    private func bind() {
        
        let input = MovieDetailViewModel.Input(fetchMovieDetail: Observable.just(()))
        
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
            .map { $0.releaseDate }
            .bind(to: movieDetailView.releaseDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.movieDetail
            .map { $0.genre }
            .bind(to: movieDetailView.genreLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
}
