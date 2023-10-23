//
//  VideoResponse.swift
//  FilmFolio
//
//  Created by 신소민 on 10/23/23.
//

import Foundation

struct VideoResponse: Decodable {
    let id: Int
    let results: [VideoData]
}
