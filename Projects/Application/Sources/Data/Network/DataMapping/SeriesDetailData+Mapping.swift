//
//  SeriesDetailData+Mapping.swift
//  FilmFolio
//
//  Created by 신소민 on 10/28/23.
//

import Foundation

extension SeriesDetailData {
    func toDomain() -> SeriesDetail {
        var posterURL: URL?
        
        if let posterPath = self.posterPath {
            posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
        
        var backdropURL: URL?
        
        if let backdropPath = self.backdropPath {
            backdropURL = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
        }
        
        return SeriesDetail(
            id: self.id,
            name: self.name,
            overview: self.overview,
            firstAirDate: self.firstAirDate,
            numberOfEpisodes: self.numberOfEpisodes,
            genre: self.genres.map { $0.name }.joined(separator: " ∙ "),
            posterURL: posterURL,
            backdropURL: backdropURL
        )
    }
}
