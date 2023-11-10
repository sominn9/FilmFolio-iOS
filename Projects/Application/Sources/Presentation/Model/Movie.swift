//
//  Movie.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/09.
//

import Foundation

struct Movie: PosterRepresentable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    private let _posterPath: String?
    
    init(id: Int, title: String, overview: String, releaseDate: String?, _posterPath: String?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self._posterPath = _posterPath
    }

    func posterURL(size: Size) -> URL? {
        guard let _posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/\(size.rawValue)\(_posterPath)")
    }
}
