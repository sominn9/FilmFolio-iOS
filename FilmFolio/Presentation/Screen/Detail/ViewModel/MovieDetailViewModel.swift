//
//  MovieDetailViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/16.
//

import Foundation
import RxSwift

struct MovieDetailViewModel {
    
    // MARK: Input & Output
    
    struct Input {
        let fetchMovieDetail: Observable<Void>
        let reviewButtonPressed: Observable<Void>
    }
    
    struct Output {
        let movieDetail: Observable<MovieDetail>
        let similarMovies: Observable<[Movie]>
        let loadedReview: Observable<Review>
    }
    
    
    // MARK: Properties
    
    private let id: Int
    private let movieRepository: MovieRepository
    private let loadReviewRepository: LoadReviewRepository
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(
        id: Int,
        movieRepository: MovieRepository = DefaultMovieRepository(),
        loadReviewRepository: LoadReviewRepository = DefaultLoadReviewRepository()
    ) {
        self.id = id
        self.movieRepository = movieRepository
        self.loadReviewRepository = loadReviewRepository
    }
    
    
    // MARK: Methods
    
    func transform(_ input: Input) -> Output {
        let movieDetail = BehaviorSubject<MovieDetail>(value: .default())
        let similarMovies = PublishSubject<[Movie]>()
        let loadedReview = PublishSubject<Review>()
        
        input.fetchMovieDetail
            .flatMap { movieRepository.detail(id) }
            .catchAndReturn(MovieDetail.default())
            .bind(to: movieDetail)
            .disposed(by: disposeBag)
        
        input.fetchMovieDetail
            .flatMap { movieRepository.similar(id) }
            .catchAndReturn([])
            .bind(to: similarMovies)
            .disposed(by: disposeBag)
        
        input.reviewButtonPressed
            .subscribe(onNext: {
                Task {
                    var review = try await loadReviewRepository.load(id: id, media: .movie)
                    review.title = (try? movieDetail.value().title) ?? ""
                    review.posterPath = try? movieDetail.value().posterPath
                    loadedReview.onNext(review)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            movieDetail: movieDetail,
            similarMovies: similarMovies,
            loadedReview: loadedReview
        )
    }
    
}
