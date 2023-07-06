//
//  TitleView.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/01.
//

import RxCocoa
import SnapKit
import UIKit

final class TitleView: UICollectionReusableView {
    
    // MARK: Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Methods
    
    private func configure() {
        self.backgroundColor = .systemBackground
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
}
