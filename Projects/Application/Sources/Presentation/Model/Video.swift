//
//  Video.swift
//  FilmFolio
//
//  Created by 신소민 on 10/23/23.
//

import Foundation

struct Video: Hashable {
    let id: String
    let name: String
    let videoURL: URL
    let thumbnailURL: URL
    let publishedAt: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (_ lhs: Video, _ rhs: Video) -> Bool {
        lhs.id == rhs.id
    }
}
