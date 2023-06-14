//
//  HomeViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/10.
//

import Foundation

final class HomeViewModel {
    
    private let networkManager: NetworkManager
    var nowPlaying: DataStorage<Movie>
    var popular: DataStorage<Movie>
    var topRated: DataStorage<Movie>
    
    init(
        networkManager: NetworkManager,
        nowPlaying: DataStorage<Movie> = .init(),
        popular: DataStorage<Movie> = .init(),
        topRated: DataStorage<Movie> = .init()
    ) {
        self.networkManager = networkManager
        self.nowPlaying = nowPlaying
        self.popular = popular
        self.topRated = topRated
    }
    
    func requestNowPlayMovies(_ completion: (([Movie]) -> Void)?) {
        let endpoint = EndpointCollection.nowPlaying()
        networkManager.request(endpoint) { [weak self] (result: Result<MovieResponse, Error>) in
            if case let .success(response) = result {
                let movies = response.movies
                self?.nowPlaying.append(contentOf: movies)
                completion?(movies)
            }
        }
    }
    
    func requestPopularMovies(_ completion: (([Movie]) -> Void)?) {
        let endpoint = EndpointCollection.popular()
        networkManager.request(endpoint) { [weak self] (result: Result<MovieResponse, Error>) in
            if case let .success(response) = result {
                let movies = response.movies
                self?.popular.append(contentOf: movies)
                completion?(movies)
            }
        }
    }
    
    func requestTopRatedMovies(_ completion: (([Movie]) -> Void)?) {
        let endpoint = EndpointCollection.topRated()
        networkManager.request(endpoint) { [weak self] (result: Result<MovieResponse, Error>) in
            if case let .success(response) = result {
                let movies = response.movies
                self?.topRated.append(contentOf: movies)
                completion?(movies)
            }
        }
    }
}
