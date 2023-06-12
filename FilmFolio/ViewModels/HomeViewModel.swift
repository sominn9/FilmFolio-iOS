//
//  HomeViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/10.
//

import Foundation

struct HomeViewModel {
    
    private let networkManager: NetworkManager
    private var array: [Movie] = []
    
    func requestNowPlayMovies(_ completion: @escaping (Result<[Movie], Error>) -> Void) {
        let endpoint = EndpointCollection.nowPlaying()
        networkManager.request(endpoint) { (result: Result<MovieResponse, Error>) in
            if case let .success(response) = result {
                completion(.success(response.movies))
                return
            }
        }
    }
}
