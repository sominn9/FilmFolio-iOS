//
//  Extension+UIButton.Configuration.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/04.
//

import UIKit

extension UIButton.Configuration {
    
    static func titleMenu(_ text: String, fontSize: CGFloat, state: UIControl.State = .normal) -> Self {
        
        // Create attributed string.
        var attributedTitle = AttributedString(text)
        attributedTitle.foregroundColor = state == .normal ? .label : .lightText
        attributedTitle.font = UIFont.boldSystemFont(ofSize: fontSize)
        
        // Create chevron image.
        var image = UIImage(systemName: "chevron.down.circle.fill")
        image = image?.withConfiguration(UIImage.SymbolConfiguration(
            pointSize: 17,
            weight: .semibold,
            scale: .default
        ))
        
        // Create button configuration.
        var configuration = UIButton.Configuration.plain()
        configuration.image = image
        configuration.imagePadding = 5
        configuration.imagePlacement = .trailing
        configuration.attributedTitle = attributedTitle
        configuration.preferredSymbolConfigurationForImage = .init(hierarchicalColor: .lightGray)
        
        return configuration
    }
}
