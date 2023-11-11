//
//  TabBarItem.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/13.
//

import SnapKit
import UIKit

public final class TabBarItem: UICollectionViewCell {
    
    // MARK: Properties
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = configuration.font
        label.textColor = configuration.textColor
        label.textAlignment = .center
        return label
    }()
    
    public override var isSelected: Bool {
        didSet {
            configure()
        }
    }
    
    public var configuration: Configuration = .default() {
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
    
    private func layout() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
    }
    
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
    
}
