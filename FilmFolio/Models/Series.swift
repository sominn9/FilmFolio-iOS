//
//  Series.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/07.
//

import Foundation

struct SeriesResponse: Decodable {
    let page: Int
    let series: [Series]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case series = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Series: Decodable, Hashable {
    private let _backdropPath: String?
    let firstAirDate: String
    let genreIDS: [Int]
    let id: Int
    let name: String
    let originCountry: [String]
    let originalLanguage: String
    let originalName: String
    let overview: String
    let popularity: Double
    private let _posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case _backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id
        case name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case _posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (_ lhs: Series, _ rhs: Series) -> Bool {
        lhs.id == rhs.id
    }
}

extension Series {
    
    enum Size: String {
        case small = "w200"
        case big = "w500"
        case original
    }
    
    func backdropPath(size: Size) -> String? {
        guard let _backdropPath else { return nil }
        return "https://image.tmdb.org/t/p/\(size.rawValue)\(_backdropPath)"
    }
    
    func posterPath(size: Size) -> String? {
        guard let _posterPath else { return nil }
        return "https://image.tmdb.org/t/p/\(size.rawValue)\(_posterPath)"
    }
    
}
