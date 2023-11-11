//
//  HomeSceneLocalization.swift
//  Resource
//
//  Created by 신소민 on 11/11/23.
//

import Foundation

public struct HomeSceneLocalization {
    
    public enum Movie: String, LocalizedStringConvertible {
        case nowPlaying
        case popular
        case topRated
        
        public var text: String {
            String(localized: .init("home-scene.movie.\(rawValue)"), bundle: Bundle.module)
        }
    }
    
    public enum Series: String, LocalizedStringConvertible {
        case onTheAir
        case popular
        case topRated
        
        public var text: String {
            String(localized: .init("home-scene.series.\(rawValue)"), bundle: Bundle.module)
        }
    }
    
}
