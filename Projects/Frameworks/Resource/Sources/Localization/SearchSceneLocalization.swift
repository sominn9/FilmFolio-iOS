//
//  SearchSceneLocalization.swift
//  Resource
//
//  Created by 신소민 on 11/11/23.
//

import Foundation

public enum SearchSceneLocalization: String, LocalizedStringConvertible {
    case title
    
    public var text: String {
        String(localized: .init("search-scene.\(rawValue)"), bundle: Bundle.module)
    }
    
    // MARK: - Movie
    
    public enum Movie: String, LocalizedStringConvertible {
        case placeholder
        
        public var text: String {
            String(localized: .init("search-scene.movie.\(rawValue)"), bundle: Bundle.module)
        }
    }
    
    // MARK: - Series
    
    public enum Series: String, LocalizedStringConvertible {
        case placeholder
        
        public var text: String {
            String(localized: .init("search-scene.series.\(rawValue)"), bundle: Bundle.module)
        }
    }
}
