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
        let nowPlaying: BehaviorSubject<[Movie]>
        let popular: BehaviorSubject<[Movie]>
        let topRated: BehaviorSubject<[Movie]>
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
        let nowPlaying = BehaviorSubject<[Movie]>(value: [])
        let popular = BehaviorSubject<[Movie]>(value: [])
        let topRated = BehaviorSubject<[Movie]>(value: [])
        
        input.fetchMovies
            .flatMap { repository.nowPlaying() }
            .catchAndReturn([])
            .subscribe(onNext: {
                nowPlaying.onNext($0)
            })
            .disposed(by: disposeBag)
        
        input.fetchMovies
            .flatMap { repository.popular() }
            .catchAndReturn([])
            .subscribe(onNext: {
                popular.onNext($0)
            })
            .disposed(by: disposeBag)
        
        input.fetchMovies
            .flatMap { repository.topRated() }
            .catchAndReturn([])
            .subscribe(onNext: {
                topRated.onNext($0)
            })
            .disposed(by: disposeBag)
        
        return MovieHomeViewModel.Output(
            nowPlaying: nowPlaying,
            popular: popular,
            topRated: topRated
        )
    }
    
}
