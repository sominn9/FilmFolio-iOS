//
//  MovieDetailData+Mapping.swift
//  FilmFolio
//
//  Created by 신소민 on 10/28/23.
//

import Foundation

extension MovieDetailData {
    func toDomain() -> MovieDetail {
        var posterURL: URL?
        
        if let posterPath = self.posterPath {
            posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
        
        var backdropURL: URL?
        
        if let backdropPath = self.backdropPath {
            backdropURL = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
        }
        
        return MovieDetail(
            id: self.id,
            title: self.title,
            overview: self.overview,
            releaseDate: self.releaseDate,
            genre: self.genres.map { $0.name }.joined(separator: " ∙ "),
            posterURL: posterURL,
            backdropURL: backdropURL
        )
    }
}
