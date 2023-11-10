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
    let backdropURL: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(media)
    }
    
    static func == (_ lhs: Upcoming, _ rhs: Upcoming) -> Bool {
        lhs.id == rhs.id && lhs.media == rhs.media
    }
}
