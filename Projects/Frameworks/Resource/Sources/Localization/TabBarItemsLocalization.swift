//
//  TabBarItemsLocalization.swift
//  Resource
//
//  Created by 신소민 on 11/11/23.
//

import Foundation

public enum TabBarItemsLocalization: String, LocalizedStringConvertible {
    case home
    case search
    case upcoming
    case review
    
    public var text: String {
        String(localized: .init("tab-bar-items.\(rawValue)"), bundle: Bundle.module)
    }
}
