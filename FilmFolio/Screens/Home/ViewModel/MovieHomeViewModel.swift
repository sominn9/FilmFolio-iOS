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
    
    private let networkManager: NetworkManager
    private let nowPlaying = PublishSubject<[Movie]>()
    private let popular = PublishSubject<[Movie]>()
    private let topRated = PublishSubject<[Movie]>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    
    // MARK: Methods
    
    func transform(_ input: MovieHomeViewModel.Input) -> MovieHomeViewModel.Output {
        
        input.fetchNowPlayMovies
            .map { EndpointCollection.nowPlayingMovies() }
            .flatMap { networkManager.request($0) }
            .map { (r: MovieResponse) in r.movies }
            .catchAndReturn([])
            .bind(to: nowPlaying)
            .disposed(by: disposeBag)
        
        input.fetchPopularMovies
            .map { EndpointCollection.popularMovies() }
            .flatMap { networkManager.request($0) }
            .map { (r: MovieResponse) in r.movies }
            .catchAndReturn([])
            .bind(to: popular)
            .disposed(by: disposeBag)
        
        input.fetchTopRatedMovies
            .map { EndpointCollection.topRatedMovies() }
            .flatMap { networkManager.request($0) }
            .map { (r: MovieResponse) in r.movies }
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
