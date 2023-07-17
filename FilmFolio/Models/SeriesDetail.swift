//
//  SeriesDetail.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/14.
//

import Foundation

struct SeriesDetail: Decodable {
    let adult: Bool
    private let _backdropPath: String?
    let firstAirDate: String
    let genres: [Genre]
    let id: Int
    let inProduction: Bool
    let lastAirDate: String
    let name: String
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let overview: String
    private let _posterPath: String?
    let status: String
    let tagline: String

    enum CodingKeys: String, CodingKey {
        case adult
        case _backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genres
        case id
        case inProduction = "in_production"
        case lastAirDate = "last_air_date"
        case name
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case overview
        case _posterPath = "poster_path"
        case status
        case tagline
    }
}

extension SeriesDetail {
    
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

extension SeriesDetail {
    
    static func `default`() -> Self {
        return .init(
            adult: false,
            _backdropPath: nil,
            firstAirDate: "",
            genres: [],
            id: 0,
            inProduction: false,
            lastAirDate: "",
            name: "",
            numberOfEpisodes: 0,
            numberOfSeasons: 0,
            overview: "",
            _posterPath: nil,
            status: "",
            tagline: ""
        )
    }
    
}
