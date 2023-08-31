//
//  Review.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/20.
//

import Foundation

struct Review: Hashable {
    let id: Int
    let media: Media
    var title: String
    var content: String
    var posterPath: String?
    var publishDate: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(media)
    }
    
    static func == (_ lhs: Review, _ rhs: Review) -> Bool {
        return lhs.id == rhs.id && lhs.media == rhs.media
    }
}
