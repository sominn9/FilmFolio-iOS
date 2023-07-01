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
        imageView.backgroundColor = .black
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
    
    func setup(_ imageURL: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: imageURL),
                  let data = try? Data(contentsOf: url) else { return }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}

private extension RoundImageCell {
    
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
