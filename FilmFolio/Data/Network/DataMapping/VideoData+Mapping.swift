//
//  VideoData+Mapping.swift
//  FilmFolio
//
//  Created by 신소민 on 10/23/23.
//

import Foundation

extension VideoData {
    func toDomain() -> Video? {
        guard official, site == .youtube else { return nil }
        
        var video = URLComponents(string: "https://www.youtube.com/watch?")
        video?.queryItems = [URLQueryItem(name: "v", value: key)]
        guard let videoURL = video?.url else { return nil }
        
        let thumbnail = URL(string: "https://img.youtube.com/vi/\(key)/0.jpg")
        guard let thumbnailURL = thumbnail else { return nil }
        
        return Video(
            id: self.id,
            name: self.name,
            videoURL: videoURL,
            thumbnailURL: thumbnailURL,
            publishedAt: self.publishedAt
        )
    }
}
