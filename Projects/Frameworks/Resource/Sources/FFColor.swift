//
//  FFColor.swift
//  Application
//
//  Created by 신소민 on 11/10/23.
//

import UIKit

public enum FFColor {
    public static var accentColor: UIColor {
        UIColor(named: "AccentColor", in: Bundle.module, compatibleWith: nil)!
    }
    public static var darkColor: UIColor { 
        UIColor(named: "DarkColor", in: Bundle.module, compatibleWith: nil)!
    }
}
