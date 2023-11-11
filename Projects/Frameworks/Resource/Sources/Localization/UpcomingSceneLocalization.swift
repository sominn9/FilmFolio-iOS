//
//  UpcomingSceneLocalization.swift
//  Resource
//
//  Created by 신소민 on 11/11/23.
//

import Foundation

public enum UpcomingSceneLocalization: String, LocalizedStringConvertible {
    case title
    
    public var text: String {
        String(localized: .init("upcoming-scene.\(rawValue)"), bundle: Bundle.module)
    }
}
