//
//  MediaLocalization.swift
//  Resource
//
//  Created by 신소민 on 11/11/23.
//

import Foundation

public enum MediaLocalization: String, LocalizedStringConvertible {
    case movie
    case series
    case animation
    
    public var text: String {
        String(localized: .init("media.\(rawValue)"), bundle: Bundle.module)
    }
}
