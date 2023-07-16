//
//  MovieDetail.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/14.
//

import Foundation

struct MovieDetail: Decodable {
    let adult: Bool
    private let _backdropPath: String?
    let genres: [Genre]
    let id: Int
    let overview: String
    private let _posterPath: String?
    let releaseDate: String
    let runtime: Int
    let status: String
    let tagline: String
    let title: String
    let video: Bool

    enum CodingKeys: String, CodingKey {
        case adult
        case _backdropPath = "backdrop_path"
        case genres
        case id
        case overview
        case _posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime
        case status
        case tagline
        case title
        case video
    }
}

extension MovieDetail {
    
    var backdropPath: String? {
        guard let _backdropPath else { return nil }
        return "https://image.tmdb.org/t/p/w780\(_backdropPath)"
    }
    
    var posterPath: String? {
        guard let _posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(_posterPath)"
    }
    
    var genre: String {
        return genres.map { $0.name }.joined(separator: " ∙ ")
    }
    
}

extension MovieDetail {
    
    static func `default`() -> Self {
        return .init(
            adult: false,
            _backdropPath: nil,
            genres: [],
            id: 0,
            overview: "",
            _posterPath: nil,
            releaseDate: "",
            runtime: 0,
            status: "",
            tagline: "",
            title: "",
            video: false
        )
    }
    
}

struct Genre: Codable {
    let id: Int
    let name: String
}
