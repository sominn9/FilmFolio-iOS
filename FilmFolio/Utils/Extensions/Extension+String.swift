//
//  Extension+String.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/17.
//

import UIKit

extension String {
    
    func withLineHeightMultiple(_ value: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = value
        return NSAttributedString(string: self, attributes: [
            .paragraphStyle: paragraphStyle
        ])
    }
}
