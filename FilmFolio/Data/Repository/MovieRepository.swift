//
//  MovieRepository.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/09/22.
//

import Foundation
import RxSwift

protocol MovieRepository {
    func nowPlaying() -> Observable<[Movie]>
    func popular() -> Observable<[Movie]>
    func topRated() -> Observable<[Movie]>
    func upcoming() -> Observable<[Upcoming]>
    func detail(_ id: Int) -> Observable<MovieDetail>
    func similar(_ id: Int) -> Observable<[Movie]>
    func search(query: String, page: Int) -> Observable<[Movie]>
    func videos(_ id: Int) -> Observable<[Video]>
}

struct DefaultMovieRepository: MovieRepository {
    
    // MARK: Properties
    
    private let networkManager: NetworkManager
    
    
    // MARK: Initializing
    
    init(networkManager: NetworkManager = DefaultNetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    
    // MARK: Methods
    
    func nowPlaying() -> Observable<[Movie]> {
        let endpoint = EndpointCollection.nowPlayingMovies()
        return networkManager.request(endpoint)
            .map { (r: TMDBResponse<MovieData>) in r.results }
            .map { $0.map { $0.toMovie() }}
    }
    
    func popular() -> Observable<[Movie]> {
        let endpoint = EndpointCollection.popularMovies()
        return networkManager.request(endpoint)
            .map { (r: TMDBResponse<MovieData>) in r.results }
            .map { $0.map { $0.toMovie() }}
    }
    
    func topRated() -> Observable<[Movie]> {
        let endpoint = EndpointCollection.topRatedMovies()
        return networkManager.request(endpoint)
            .map { (r: TMDBResponse<MovieData>) in r.results }
            .map { $0.map { $0.toMovie() }}
    }
    
    func upcoming() -> Observable<[Upcoming]> {
        let endpoint = EndpointCollection.upcomingMovie(date: Date.tomorrow())
        return networkManager.request(endpoint)
            .map { (r: TMDBResponse<MovieData>) in r.results }
            .map { $0.compactMap { $0.toUpcoming() } }
    }
    
    func detail(_ id: Int) -> Observable<MovieDetail> {
        let endpoint = EndpointCollection.movieDetail(id: id)
        return networkManager.request(endpoint)
            .map { (r: MovieDetailData) in r.toDomain() }
    }
    
    func similar(_ id: Int) -> Observable<[Movie]> {
        let endpoint = EndpointCollection.similarMovies(id: id)
        return networkManager.request(endpoint)
            .map { (r: TMDBResponse<MovieData>) in r.results }
            .map { $0.map { $0.toMovie() }}
    }
    
    func search(query: String, page: Int) -> Observable<[Movie]> {
        let endpoint = EndpointCollection.searchMovie(query: query, page: page)
        return networkManager.request(endpoint)
            .map { (r: TMDBResponse<MovieData>) in r.results }
            .map { $0.map { $0.toMovie() }}
    }
    
    func videos(_ id: Int) -> Observable<[Video]> {
        let endpoint = EndpointCollection.movieVideos(id: id)
        return networkManager.request(endpoint)
            .map { (r: VideoResponse) in r.results }
            .map { $0.compactMap { $0.toDomain() } }
    }
}
