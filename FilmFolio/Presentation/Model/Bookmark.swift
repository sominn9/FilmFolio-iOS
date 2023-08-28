//
//  Bookmark.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/20.
//

import Foundation

struct Bookmark {
    let id: Int
    let media: Media
    let title: String
    let overview: String
    let posterPath: String
    let bookmarkDate: Date
    
    init(id: Int, media: Media, title: String, overview: String, posterPath: String, bookmarkDate: Date) {
        self.id = id
        self.media = media
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.bookmarkDate = bookmarkDate
    }
}
