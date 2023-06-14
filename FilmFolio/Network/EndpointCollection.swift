//
//  EndpointCollection.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/12.
//

import Foundation

struct EndpointCollection {
    
    static func nowPlaying() -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/movie/now_playing",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko", "region": "KR"]
        )
    }
    
    static func popular() -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/movie/popular",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko", "region": "KR"]
        )
    }
    
    static func topRated() -> Endpoint {
        return Endpoint(
            method: .GET,
            urlString: "https://api.themoviedb.org/3/movie/top_rated",
            header: ["Authorization": "Bearer \(API.accessToken)"],
            query: ["language": "ko", "region": "KR"]
        )
    }
}
