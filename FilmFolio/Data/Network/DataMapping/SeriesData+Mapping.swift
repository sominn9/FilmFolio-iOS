//
//  SeriesData+Mapping.swift
//  FilmFolio
//
//  Created by 신소민 on 10/28/23.
//

import Foundation

extension SeriesData {
    func toSeries() -> Series {
         return Series(
            id: self.id,
            name: self.name,
            overview: self.overview,
            firstAirDate: self.firstAirDate,
            _posterPath: self.posterPath
         )
    }
    
    func toUpcoming() -> Upcoming? {
        guard let firstAirDate,
              let backdropPath,
              !overview.isEmpty else { return nil }
        
        return Upcoming(
            id: self.id,
            media: .series,
            title: self.name,
            overview: self.overview,
            releaseDate: firstAirDate,
            backdropURL: URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
        )
    }
}
