//
//  TabBarItem.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/13.
//

import SnapKit
import UIKit

final class TabBarItem: UICollectionViewCell {
    
    // MARK: Configuration
    
    struct Configuration {
        
        var title: String?
        var font: UIFont
        var textColor: UIColor
        var selectedFont: UIFont
        var selectedTextColor: UIColor
        
        static func `default`() -> TabBarItem.Configuration {
            return .init(
                font: UIFont.systemFont(ofSize: 15.0),
                textColor: .darkGray,
                selectedFont: UIFont.systemFont(ofSize: 15.0, weight: .bold),
                selectedTextColor: .tintColor
            )
        }
    }
    
    
    // MARK: Properties
    
    static let id = String(describing: TabBarItem.self)
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = configuration.font
        label.textColor = configuration.textColor
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            configure()
        }
    }
    
    var configuration: Configuration = .default() {
        didSet {
            configure()
        }
    }
    
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Methods
    
    private func configure() {
        if isSelected {
            label.text = configuration.title
            label.font = configuration.selectedFont
            label.textColor = configuration.selectedTextColor
        } else {
            label.text = configuration.title
            label.font = configuration.font
            label.textColor = configuration.textColor
        }
    }
    
    private func layout() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
    }
}
