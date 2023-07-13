//
//  Movie.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/09.
//

import Foundation

struct Movie: Decodable, Hashable {
    let adult: Bool
    private let _backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    private let _posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case _backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case _posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (_ lhs: Movie, _ rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}

extension Movie {
    
    enum Size: String {
        case small = "w200"
        case big = "w500"
        case original
    }
    
    func backdropPath(size: Size) -> String {
        return "https://image.tmdb.org/t/p/\(size.rawValue)\(_backdropPath)"
    }
    
    func posterPath(size: Size) -> String {
        return "https://image.tmdb.org/t/p/\(size.rawValue)\(_posterPath)"
    }
    
}
