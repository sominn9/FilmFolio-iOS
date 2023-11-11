//
//  ReviewSceneLocalization.swift
//  Resource
//
//  Created by 신소민 on 11/11/23.
//

import Foundation

public enum ReviewSceneLocalization: String, LocalizedStringConvertible {
    case title
    case placeholder
    
    public var text: String {
        String(localized: .init("review-scene.\(rawValue)"), bundle: Bundle.module)
    }
}
