//
//  MovieDetailData.swift
//  FilmFolio
//
//  Created by 신소민 on 10/28/23.
//

import Foundation

struct MovieDetailData: Decodable {
    let adult: Bool
    let backdropPath: String?
    let genres: [Genre]
    let id: Int
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let runtime: Int
    let status: String
    let tagline: String
    let title: String
    let video: Bool

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genres
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime
        case status
        case tagline
        case title
        case video
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
