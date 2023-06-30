//
//  HomeView.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/06/30.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeView: UIView {
    
    // MARK: Constant
    
    struct Metric {
        static let gridCollectionViewHeight = 240
    }
    
    
    // MARK: Properties

    lazy var nowPlayCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.carousel()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: Layout.padding, bottom: 0, right: 0)
        return collectionView
    }()
    
    lazy var popularCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.grid()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    lazy var topRatedCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.grid()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI

private extension HomeView {
    
    func configure() {
        // UIView -> UIScrollView -> UIStackView -> ...
        let scrollView = configureScrollView(self)
        let stackView  = configureStackView(scrollView)
        configureCollectionView(stackView)
    }
    
    func configureScrollView(_ parent: UIView) -> UIScrollView {
        
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        
        parent.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(parent)
        }
        
        return scrollView
    }
    
    func configureStackView(_ parent: UIView) -> UIStackView {

        let stackView = UIStackView(arrangedSubviews: [
            nowPlayCollectionView,
            popularCollectionView,
            topRatedCollectionView
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Layout.padding
        
        parent.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(parent)
            make.width.equalTo(parent.snp.width)
        }
        
        return stackView
    }
    
    func configureCollectionView(_ parent: UIView) {
        
        nowPlayCollectionView.snp.makeConstraints { make in
            make.left.equalTo(parent.snp.left)
            make.right.equalTo(parent.snp.right)
            make.bottom.equalTo(parent.snp.centerY).offset(-50)
        }
        
        popularCollectionView.snp.makeConstraints { make in
            make.left.equalTo(parent.snp.left)
            make.right.equalTo(parent.snp.right)
            make.height.equalTo(Metric.gridCollectionViewHeight)
        }
        
        topRatedCollectionView.snp.makeConstraints { make in
            make.left.equalTo(parent.snp.left)
            make.right.equalTo(parent.snp.right)
            make.height.equalTo(Metric.gridCollectionViewHeight)
        }
    }
    
}
