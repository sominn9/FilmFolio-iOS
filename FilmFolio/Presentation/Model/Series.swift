//
//  Series.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/07.
//

import Foundation

struct Series: PosterRepresentable {
    let id: Int
    let name: String
    let overview: String
    let firstAirDate: String?
    private let _posterPath: String?
    
    init(id: Int, name: String, overview: String, firstAirDate: String?, _posterPath: String?) {
        self.id = id
        self.name = name
        self.overview = overview
        self.firstAirDate = firstAirDate
        self._posterPath = _posterPath
    }

    func posterURL(size: Size) -> URL? {
        guard let _posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/\(size.rawValue)\(_posterPath)")
    }
}
