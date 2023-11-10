//
//  SeriesDetail.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/14.
//

import Foundation

struct SeriesDetail {
    let id: Int
    let name: String
    let overview: String
    let firstAirDate: String
    let numberOfEpisodes: Int
    let genre: String
    let posterURL: URL?
    let backdropURL: URL?
    
    static func `default`() -> Self {
        return SeriesDetail(
            id: 0,
            name: "",
            overview: "",
            firstAirDate: "",
            numberOfEpisodes: 0,
            genre: "",
            posterURL: nil,
            backdropURL: nil
        )
    }
}
