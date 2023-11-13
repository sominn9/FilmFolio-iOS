//
//  Extension+UIButton.Configuration.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/04.
//

import UIKit

public extension UIButton.Configuration {
    
    static func titleMenu(
        _ text: String,
        fontSize: CGFloat,
        state: UIControl.State = .normal,
        showChevron: Bool = true
    ) -> Self {
        
        // Create attributed string.
        var attributedTitle = AttributedString(text)
        attributedTitle.foregroundColor = state == .normal ? .label : .lightText
        attributedTitle.font = UIFont.boldSystemFont(ofSize: fontSize)
        
        // Create button configuration.
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = attributedTitle
        guard showChevron else { return configuration }
        
        // Create chevron image.
        var image = UIImage(systemName: "chevron.down.circle.fill")
        image = image?.withConfiguration(UIImage.SymbolConfiguration(
            pointSize: 17,
            weight: .semibold,
            scale: .default
        ))
        
        configuration.image = image
        configuration.imagePadding = 5
        configuration.imagePlacement = .trailing
        configuration.preferredSymbolConfigurationForImage = .init(hierarchicalColor: .lightGray)
        return configuration
    }
    
}
