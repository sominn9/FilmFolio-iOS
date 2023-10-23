//
//  VideoData.swift
//  FilmFolio
//
//  Created by 신소민 on 10/23/23.
//

import Foundation

struct VideoData: Decodable {
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let key: String
    let site: Site
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case iso_639_1
        case iso_3166_1
        case name
        case key
        case site
        case size
        case type
        case official
        case publishedAt = "published_at"
        case id
    }
}

enum Site: String, Decodable {
    case youtube = "YouTube"
    case vimeo = "Vimeo"
}
