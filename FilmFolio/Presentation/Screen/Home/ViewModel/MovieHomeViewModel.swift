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
        let fetchMovies: Observable<Void>
    }
    
    struct Output {
        let nowPlaying: PublishSubject<[Movie]>
        let popular: PublishSubject<[Movie]>
        let topRated: PublishSubject<[Movie]>
    }
    
    
    // MARK: Properties
    
    private let repository: MovieRepository
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(repository: MovieRepository = DefaultMovieRepository()) {
        self.repository = repository
    }
    
    
    // MARK: Methods
    
    func transform(_ input: MovieHomeViewModel.Input) -> MovieHomeViewModel.Output {
        let nowPlaying = PublishSubject<[Movie]>()
        let popular = PublishSubject<[Movie]>()
        let topRated = PublishSubject<[Movie]>()
        
        input.fetchMovies
            .flatMap { repository.nowPlaying() }
            .catchAndReturn([])
            .bind(to: nowPlaying)
            .disposed(by: disposeBag)
        
        input.fetchMovies
            .flatMap { repository.popular() }
            .catchAndReturn([])
            .bind(to: popular)
            .disposed(by: disposeBag)
        
        input.fetchMovies
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
