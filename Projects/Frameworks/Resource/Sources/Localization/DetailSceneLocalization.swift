//
//  DetailSceneLocalization.swift
//  Resource
//
//  Created by 신소민 on 11/11/23.
//

import Foundation

public struct DetailSceneLocalization {
    
    public enum Movie: String, LocalizedStringConvertible {
        case release
        
        public var text: String {
            String(localized: .init("detail-scene.movie.\(rawValue)"), bundle: Bundle.module)
        }
    }
    
    public enum Series: String, LocalizedStringConvertible {
        case firstAir
        case episodes
        
        public var text: String {
            String(localized: .init("detail-scene.series.\(rawValue)"), bundle: Bundle.module)
        }
    }
    
}
