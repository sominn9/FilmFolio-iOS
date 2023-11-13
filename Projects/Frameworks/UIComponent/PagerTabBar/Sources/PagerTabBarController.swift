//
//  PagerTabBarController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/13.
//

import SnapKit
import UIKit

public protocol PagerTabBarControllerDataSource: AnyObject {
    func tabBarTitles(_ pagerTabBarController: PagerTabBarController) -> [String]
    func viewControllers(_ pagerTabBarController: PagerTabBarController) -> [UIViewController]
}

public final class PagerTabBarController: UIViewController {

    // MARK: - Public Properties
    
    public weak var dataSource: PagerTabBarControllerDataSource? {
        didSet {
            addChildViewControllers()
            configureTabBarDataSource()
        }
    }
    
    public var configuration: Configuration = .default() {
        didSet {
            updateConfiguration()
        }
    }
    
    
    // MARK: - Private Properties
    
    private lazy var tabBarCollectionView: UICollectionView = {
        let tabBarItemWidth = configuration.tabBarItemWidth
        let layout = tabBarLayout(itemWidth: tabBarItemWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        let inset = configuration.tabBarHorizontalInset
        collectionView.contentInset = .init(top: 0, left: inset, bottom: 0, right: inset)
        return collectionView
    }()
    
    private lazy var indicator: UIView =  {
        let view = UIView()
        view.layer.zPosition = 999
        view.backgroundColor = configuration.indicatorColor
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.decelerationRate = .fast
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private var tabBarDataSource: UICollectionViewDiffableDataSource<Int, String>?
    
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    public override func viewDidLayoutSubviews() {
        configureChildViewControllers()
        updateIndicatorHeight()
        updateIndicatorPosition(index: 0, animated: false)
    }
    
    
    // MARK: - Methods
    
    private func layout() {
        view.addSubview(tabBarCollectionView)
        tabBarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(configuration.tabBarHeight)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(tabBarCollectionView.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        tabBarCollectionView.addSubview(indicator)
    }
    
    private func addChildViewControllers() {
        guard let dataSource else {
            fatalError("Datasource must not be nil")
        }
        
        for vc in dataSource.viewControllers(self) {
            addChild(vc)
            scrollView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    
    private func configureChildViewControllers() {
        for (i, vc) in self.children.enumerated() {
            vc.view.frame = CGRect(
                x: scrollView.frame.width * CGFloat(i),
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height
            )
        }
        
        scrollView.contentSize = .init(
            width: scrollView.frame.width * CGFloat(children.count),
            height: scrollView.frame.height
        )
    }
    
    private func configureTabBarDataSource() {
        let registration = UICollectionView.CellRegistration<TabBarItem, String> { [weak self] cell, _, title in
            if let self {
                var configuration = self.configuration.tabBarItemConfiguration
                configuration.title = title
                cell.configuration = configuration
            } else {
                var configuration = TabBarItem.Configuration.default()
                configuration.title = title
                cell.configuration = configuration
            }
        }
        
        tabBarDataSource = UICollectionViewDiffableDataSource<Int, String>(
            collectionView: tabBarCollectionView,
            cellProvider: { collectionView, indexPath, title in
                return collectionView.dequeueConfiguredReusableCell(
                    using: registration,
                    for: indexPath,
                    item: title
                )
            }
        )
        
        applyTabBarDataSourceSnapshot()
    }
    
    private func applyTabBarDataSourceSnapshot() {
        guard let dataSource else {
            fatalError("Datasource must not be nil")
        }
        
        guard dataSource.tabBarTitles(self).count == dataSource.viewControllers(self).count else {
            fatalError("The number of titles and view controllers must be the same.")
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(dataSource.tabBarTitles(self))
        tabBarDataSource?.apply(snapshot)
        tabBarCollectionView.selectItem(at: .init(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    
    // MARK: - Update
    
    private func updateConfiguration() {
        // Update the collection view layout.
        let newItemWidth = configuration.tabBarItemWidth
        let newLayout = tabBarLayout(itemWidth: newItemWidth)
        tabBarCollectionView.collectionViewLayout = newLayout
        
        // Update the collection view inset.
        let inset = configuration.tabBarHorizontalInset
        tabBarCollectionView.contentInset = .init(top: 0, left: inset, bottom: 0, right: inset)
        
        // Update the collection view height.
        tabBarCollectionView.snp.updateConstraints { make in
            make.height.equalTo(configuration.tabBarHeight)
        }
        
        applyTabBarDataSourceSnapshot()
        
        // Update the indicator.
        indicator.backgroundColor = configuration.indicatorColor
        updateIndicatorHeight()
    }
    
    private func updateIndicatorHeight() {
        var indicatorFrame = indicator.frame
        indicatorFrame.origin.y = configuration.tabBarHeight - configuration.indicatorHeight
        indicatorFrame.size.height = configuration.indicatorHeight
        indicator.frame = indicatorFrame
    }
    
    private func updateIndicatorPosition(index: Int, animated: Bool) {
        // Gets the cells in a specific location.
        let selectedCellIndexPath = IndexPath(item: index, section: 0)
        let selectedCell = tabBarCollectionView.cellForItem(at: selectedCellIndexPath)
        let selectedCellFrame = selectedCell?.frame ?? .zero
        
        // Adjust the origin.x and height of the indicator to fit the cell.
        var indicatorFrame = indicator.frame
        indicatorFrame.origin.x = selectedCellFrame.origin.x
        indicatorFrame.size.width = configuration.tabBarItemWidth
        
        // Animate the changes.
        if animated {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.indicator.frame = indicatorFrame
            }
        } else {
            self.indicator.frame = indicatorFrame
        }
    }

}

// MARK: - UICollectionViewDelegate

extension PagerTabBarController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        updateIndicatorPosition(index: indexPath.row, animated: true)
        UIView.animate(withDuration: 0.3) { [weak self] in
            let offsetX = CGFloat(indexPath.row) * (self?.scrollView.frame.width ?? 0)
            self?.scrollView.contentOffset.x = offsetX
        }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
        let index = targetContentOffset.pointee.x / scrollView.frame.width
        let roundedIndex = Int(round(index))
        let indexPath = IndexPath(item: roundedIndex, section: 0)
        collectionView(tabBarCollectionView, didSelectItemAt: indexPath)
    }
    
}

// MARK: - UICollectionViewCompositionalLayout

private extension PagerTabBarController {
    
    func tabBarLayout(itemWidth: CGFloat) -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { _, _ in
            
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1))
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .absolute(itemWidth),
                    heightDimension: .fractionalHeight(1)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        let config = layout.configuration
        config.scrollDirection = .horizontal
        layout.configuration = config
        return layout
    }
    
}
