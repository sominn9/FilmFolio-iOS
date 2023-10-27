//
//  MovieData+Mapping.swift
//  FilmFolio
//
//  Created by 신소민 on 10/28/23.
//

import Foundation

extension MovieData {
    func toMovie() -> Movie {
         return Movie(
            id: self.id,
            title: self.title,
            overview: self.overview,
            releaseDate: self.releaseDate,
            _posterPath: self.posterPath
         )
    }
    
    func toUpcoming() -> Upcoming? {
        guard let releaseDate,
              let backdropPath,
              !overview.isEmpty else { return nil }
        
        return Upcoming(
            id: self.id,
            media: .movie,
            title: self.title,
            overview: self.overview,
            releaseDate: releaseDate,
            backdropURL: URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
        )
    }
}
