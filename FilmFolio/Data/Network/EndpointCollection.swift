//
//  EndpointCollection.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/12.
//

import Foundation

struct EndpointCollection {
    
    // MARK: - Movie
    
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
    
    static func movieDetail(id: Int) -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/movie/\(id)",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko"]
        )
    }
    
    static func similarMovies(id: Int) -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/movie/\(id)/similar",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko"]
        )
    }
    
    static func movieVideos(id: Int) -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/movie/\(id)/videos",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko"]
        )
    }
    
    // MARK: - Series
    
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
    
    static func seriesDetail(id: Int) -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/tv/\(id)",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko"]
        )
    }
    
    static func similarSeries(id: Int) -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/tv/\(id)/similar",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko"]
        )
    }
    
    // MARK: - Search
    
    static func searchMovie(query: String, page: Int = 1) -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/search/movie",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: [
                "query": query,
                "language": "ko",
                "page": "\(page)"
            ]
        )
    }
    
    static func searchSeries(query: String, page: Int = 1) -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/search/tv",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: [
                "query": query,
                "language": "ko",
                "page": "\(page)"
            ]
        )
    }
    
    // MARK: - Upcoming
    
    static func upcomingMovie(date: String, page: Int = 1) -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/discover/movie",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: [
                "language": "ko",
                "primary_release_date.gte": date,
                "page": "\(page)"
            ]
        )
    }
    
    static func upcomingSeries(date: String, page: Int = 1) -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/discover/tv",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: [
                "language": "ko",
                "first_air_date.gte": date,
                "page": "\(page)"
            ]
        )
    }
    
}
