//
//  PlayView.swift
//  FilmFolio
//
//  Created by 신소민 on 10/24/23.
//

import SnapKit
import UIKit

final class PlayView: UICollectionReusableView {
    
    private lazy var playButton: UIButton = {
        let button = UIButton(configuration: .plain())
        let playImage = UIImage(systemName: "play.fill")
        button.setImage(playImage, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.center.equalTo(self.snp.center)
            $0.height.equalTo(100)
            $0.width.equalTo(playButton.snp.height)
        }
    }
    
}
