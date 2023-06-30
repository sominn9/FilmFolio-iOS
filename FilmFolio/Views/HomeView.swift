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
    
    // MARK: Constants

    struct Metric {
        static let carouselCollectionViewSpacing: CGFloat = 16.0
        static let gridCollectionViewSpacing: CGFloat = 8.0
        static let gridCollectionViewInset: CGFloat = 16.0
        
        /// Calculate the height of a collection view that shows only two rows.
        /// - Parameters:
        ///   - width: Collection view's container width.
        ///   - columnCount: The number of columns in a collection view
        /// - Returns: Height of a collection view with only 2 rows.
        static func gridCollectionViewHeight(
            _ width: CGFloat,
            _ columnCount: CGFloat = 3
        ) -> CGFloat {
            let contentWidth = width - gridCollectionViewInset * 2.0
            let spacingCount = columnCount - 1.0
            let itemWidth = (contentWidth - gridCollectionViewSpacing * spacingCount) / columnCount
            let itemHeight = itemWidth * 3.0 / 2.0
            return itemHeight * 2.0 + gridCollectionViewSpacing
        }
    }
    
    
    // MARK: Properties
    
    lazy var nowPlayCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.carousel(
            spacing: Metric.carouselCollectionViewSpacing
        )
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = false
        collectionView.bouncesZoom = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: Layout.padding, bottom: 0, right: 0)
        return collectionView
    }()
    
    lazy var popularCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.grid(
            spacing: Metric.gridCollectionViewSpacing,
            inset: Metric.gridCollectionViewInset
        )
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    lazy var topRatedCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.grid(
            spacing: Metric.gridCollectionViewSpacing,
            inset: Metric.gridCollectionViewInset
        )
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let screenSize: CGSize
    

    // MARK: Initializing
    
    init(screenSize: CGSize) {
        self.screenSize = screenSize
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View Update Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = Metric.gridCollectionViewHeight(bounds.width)
        
        popularCollectionView.snp.makeConstraints {
            $0.height.equalTo(height)
        }
        
        topRatedCollectionView.snp.makeConstraints {
            $0.height.equalTo(height)
        }
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
            make.height.equalTo(screenSize.height * 3.0 / 7.0)
        }
        
        popularCollectionView.snp.makeConstraints { make in
            make.left.equalTo(parent.snp.left)
            make.right.equalTo(parent.snp.right)
        }
        
        topRatedCollectionView.snp.makeConstraints { make in
            make.left.equalTo(parent.snp.left)
            make.right.equalTo(parent.snp.right)
        }
    }
    
}
