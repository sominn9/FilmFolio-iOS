//
//  HomeViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/10.
//

import Foundation

final class HomeViewModel {
    
    private let networkManager: NetworkManager
    private var nowPlaying: DataStorage<Movie>
    
    init(networkManager: NetworkManager, nowPlaying: DataStorage<Movie>) {
        self.networkManager = networkManager
        self.nowPlaying = nowPlaying
    }
    
    func requestNowPlayMovies(_ completion: @escaping (Result<[Movie], Error>) -> Void) {
        let endpoint = EndpointCollection.nowPlaying()
        networkManager.request(endpoint) { [weak self] (result: Result<MovieResponse, Error>) in
            if case let .success(response) = result {
                let movies = response.movies
                self?.nowPlaying.append(contentOf: movies)
            }
        }
    }
}
