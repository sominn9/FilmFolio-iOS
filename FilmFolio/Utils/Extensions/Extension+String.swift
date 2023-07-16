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
    
    func withBold(target: String, _ textColor: UIColor, _ fontSize: CGFloat = 17.0) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(
            .foregroundColor,
            value: textColor,
            range: NSString(string: self).range(of: target)
        )
        attributedString.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: fontSize, weight: .bold),
            range: NSString(string: self).range(of: target)
        )
        return attributedString as NSAttributedString
    }
}
