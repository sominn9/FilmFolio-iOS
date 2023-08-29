//
//  Review.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/20.
//

import Foundation

struct Review {
    let id: Int
    let media: Media
    var title: String
    var content: String
    let posterPath: String?
    var publishDate: String
}
