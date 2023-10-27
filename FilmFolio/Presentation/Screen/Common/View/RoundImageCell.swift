//
//  RoundImageCell.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/05/10.
//

import SnapKit
import UIKit

final class RoundImageCell: UICollectionViewCell {
    
    // MARK: Constants
    
    struct Metric {
        static let cornerRadius: CGFloat = 8.0
    }
    
    
    // MARK: Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "darkColor")
        imageView.contentMode = .scaleAspectFill
        return imageView
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setup(_ urlString: String?) {
        Task {
            guard let urlString else { return }
            imageView.image = await ImageStorage.shared.image(for: urlString)
        }
    }
    
    func setup(_ url: URL?) {
        Task {
            guard let url else { return }
            imageView.image = await ImageStorage.shared.image(for: url.absoluteString)
        }
    }
    
    private func configure() {
        contentView.layer.cornerRadius = Metric.cornerRadius
        contentView.layer.cornerCurve = .continuous
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
}
