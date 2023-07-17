//
//  Upcoming.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/18.
//

import Foundation

struct Upcoming: Hashable {
    let type: Menus
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    private let _posterPath: String?
    private let _backdropPath: String?
    
    init(type: Menus, id: Int, title: String, overview: String, releaseDate: String, _posterPath: String?, _backdropPath: String?) {
        self.type = type
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self._posterPath = _posterPath
        self._backdropPath = _backdropPath
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
    }
    
    static func == (_ lhs: Upcoming, _ rhs: Upcoming) -> Bool {
        lhs.id == rhs.id && lhs.type == rhs.type
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
