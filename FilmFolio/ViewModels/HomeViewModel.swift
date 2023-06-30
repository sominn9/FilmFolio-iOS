//
//  HomeViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/10.
//

import Foundation
import RxSwift

struct HomeViewModel {
    
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
    
    
    // MARK: Inits
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    
    // MARK: Methods
    
    func transform(_ input: HomeViewModel.Input) -> HomeViewModel.Output {
        
        input.fetchNowPlayMovies
            .map { EndpointCollection.nowPlaying() }
            .subscribe(onNext: { endpoint in
                self.fetchMovies(endpoint, \.nowPlaying)
            })
            .disposed(by: disposeBag)
        
        input.fetchPopularMovies
            .map { EndpointCollection.popular() }
            .subscribe(onNext: { endpoint in
                self.fetchMovies(endpoint, \.popular)
            })
            .disposed(by: disposeBag)
        
        input.fetchTopRatedMovies
            .map { EndpointCollection.topRated() }
            .subscribe(onNext: { endpoint in
                self.fetchMovies(endpoint, \.topRated)
            })
            .disposed(by: disposeBag)
        
        return HomeViewModel.Output(
            nowPlaying: nowPlaying,
            popular: popular,
            topRated: topRated
        )
    }
    
    private func fetchMovies(_ endpoint: Endpoint, _ keyPath: KeyPath<HomeViewModel, PublishSubject<[Movie]>>) {
        networkManager.request(endpoint) { (result: Result<MovieResponse, Error>) in
            if case let .success(response) = result {
                let movies = response.movies
                self[keyPath: keyPath].onNext(movies)
            }
        }
    }
}
