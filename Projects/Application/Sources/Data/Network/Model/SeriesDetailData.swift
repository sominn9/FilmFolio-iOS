//
//  SeriesDetailData.swift
//  FilmFolio
//
//  Created by 신소민 on 10/28/23.
//

import Foundation

struct SeriesDetailData: Decodable {
    let adult: Bool
    let backdropPath: String?
    let firstAirDate: String
    let genres: [Genre]
    let id: Int
    let inProduction: Bool
    let lastAirDate: String
    let name: String
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let overview: String
    let posterPath: String?
    let status: String
    let tagline: String

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genres
        case id
        case inProduction = "in_production"
        case lastAirDate = "last_air_date"
        case name
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case overview
        case posterPath = "poster_path"
        case status
        case tagline
    }
}
