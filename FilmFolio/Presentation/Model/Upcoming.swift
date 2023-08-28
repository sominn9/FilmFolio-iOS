//
//  Upcoming.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/18.
//

import Foundation

struct Upcoming: Hashable {
    let id: Int
    let media: Media
    let title: String
    let overview: String
    let releaseDate: String
    private let _posterPath: String?
    private let _backdropPath: String?
    
    init(id: Int, media: Media, title: String, overview: String, releaseDate: String, _posterPath: String?, _backdropPath: String?) {
        self.id = id
        self.media = media
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self._posterPath = _posterPath
        self._backdropPath = _backdropPath
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(media)
    }
    
    static func == (_ lhs: Upcoming, _ rhs: Upcoming) -> Bool {
        lhs.id == rhs.id && lhs.media == rhs.media
    }
}

extension Upcoming {
    
    var backdropPath: String? {
        guard let _backdropPath else { return nil }
        return "https://image.tmdb.org/t/p/w780\(_backdropPath)"
    }
    
    var posterPath: String? {
        guard let _posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w342\(_posterPath)"
    }
    
}
