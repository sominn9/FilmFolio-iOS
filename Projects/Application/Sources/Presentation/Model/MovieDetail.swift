//
//  MovieDetail.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/14.
//

import Foundation

struct MovieDetail {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let genre: String
    let posterURL: URL?
    let backdropURL: URL?
    
    static func `default`() -> Self {
        return MovieDetail(
            id: 0,
            title: "",
            overview: "",
            releaseDate: "",
            genre: "",
            posterURL: nil,
            backdropURL: nil
        )
    }
}
