//
//  EndpointCollection.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/12.
//

import Foundation

struct EndpointCollection {
    
    // MARK: Movie
    
    static func nowPlayingMovies() -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/movie/now_playing",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko", "region": "KR"]
        )
    }
    
    static func popularMovies() -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/movie/popular",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko", "region": "KR"]
        )
    }
    
    static func topRatedMovies() -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/movie/top_rated",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko", "region": "KR"]
        )
    }
    
    // MARK: Series
    
    static func trendingSeries() -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/trending/tv/week",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko"]
        )
    }
    
    static func onTheAirSeries(page: Int = 1) -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/tv/on_the_air",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: [
                "language": "ko",
                "page": "\(page)",
                "timezone": "KR"
            ]
        )
    }
    
    static func topRatedSeries(page: Int = 1) -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/tv/top_rated",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: [
                "language": "ko",
                "page": "\(page)"
            ]
        )
    }
}
