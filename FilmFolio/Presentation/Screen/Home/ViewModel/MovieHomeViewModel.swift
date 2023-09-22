//
//  MovieHomeViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/10.
//

import Foundation
import RxSwift

struct MovieHomeViewModel {
    
    // MARK: Input & Output
    
    struct Input {
        let fetchNowPlayMovies: Observable<Void>
        let fetchPopularMovies: Observable<Void>
        let fetchTopRatedMovies: Observable<Void>
    }
    
    struct Output {
        let nowPlaying: PublishSubject<[Movie]>
        let popular: PublishSubject<[Movie]>
        let topRated: PublishSubject<[Movie]>
    }
    
    
    // MARK: Properties
    
    private let repository: MovieRepository
    private let nowPlaying = PublishSubject<[Movie]>()
    private let popular = PublishSubject<[Movie]>()
    private let topRated = PublishSubject<[Movie]>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(repository: MovieRepository = DefaultMovieRepository()) {
        self.repository = repository
    }
    
    
    // MARK: Methods
    
    func transform(_ input: MovieHomeViewModel.Input) -> MovieHomeViewModel.Output {
        
        input.fetchNowPlayMovies
            .flatMap { repository.nowPlaying() }
            .catchAndReturn([])
            .bind(to: nowPlaying)
            .disposed(by: disposeBag)
        
        input.fetchPopularMovies
            .flatMap { repository.popular() }
            .catchAndReturn([])
            .bind(to: popular)
            .disposed(by: disposeBag)
        
        input.fetchTopRatedMovies
            .flatMap { repository.topRated() }
            .catchAndReturn([])
            .bind(to: topRated)
            .disposed(by: disposeBag)
        
        return MovieHomeViewModel.Output(
            nowPlaying: nowPlaying,
            popular: popular,
            topRated: topRated
        )
    }
    
}
