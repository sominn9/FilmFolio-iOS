//
//  CardCell.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/05/10.
//

import UIKit

final class CardCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}

private extension CardCell {
    
    private func configure() {
        contentView.layer.cornerRadius = Layout.radius
        contentView.layer.cornerCurve = .continuous
        contentView.layer.masksToBounds = true
        configureImageView()
    }
    
    private func configureImageView() {
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
