import SnapKit
import UIKit

protocol PagerTabBarControllerDataSource: AnyObject {
    func tabBarTitles(_ pagerTabBarController: PagerTabBarController) -> [String]
    func viewControllers(_ pagerTabBarController: PagerTabBarController) -> [UIViewController]
}

final class PagerTabBarController: UIViewController {
            
    // MARK: Properties
    
    private lazy var tabBarCollectionView: UICollectionView = {
        let layout = PagerTabBarController.tabBarCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        collectionView.register(TabBarItem.self, forCellWithReuseIdentifier: TabBarItem.id)
        collectionView.selectItem(at: .init(item: 0, section: 0), animated: false, scrollPosition: .left)
        return collectionView
    }()
    
    private lazy var indicator: UIView =  {
        let view = UIView()
        view.backgroundColor = .tintColor
        view.layer.zPosition = 999
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.decelerationRate = .fast
        return scrollView
    }()
    
    var indicatorHeight: CGFloat = 3.0
    
    var tabBarHeight: CGFloat = 40.0
    
    public weak var dataSource: PagerTabBarControllerDataSource?
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        loadViewControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureViewControllers()
        updateIndicatorHeight()
        updateIndicatorPosition(index: 0, animated: false)
    }
    
    
    // MARK: Methods
    
    private func layout() {
        // 탭 바 컬렉션뷰
        view.addSubview(tabBarCollectionView)
        tabBarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(tabBarHeight)
        }
        
        // 스크롤뷰
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(tabBarCollectionView.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        // 인디케이터
        tabBarCollectionView.addSubview(indicator)
    }
    
    private func loadViewControllers() {
        guard let dataSource else { fatalError("Datasource must not be nil") }
        dataSource.viewControllers(self).forEach {
            addChild($0)
            scrollView.addSubview($0.view)
            $0.didMove(toParent: self)
        }
    }
    
    private func configureViewControllers() {
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
    
    private func updateIndicatorHeight() {
        var indicatorFrame = indicator.frame
        indicatorFrame.origin.y = tabBarCollectionView.frame.height - indicatorHeight
        indicatorFrame.size.height = indicatorHeight
        indicator.frame = indicatorFrame
    }
    
    private func updateIndicatorPosition(index: Int, animated: Bool) {
        let selectedCellIndexPath = IndexPath(item: index, section: 0)
        let selectedCell = tabBarCollectionView.cellForItem(at: selectedCellIndexPath)
        let selectedCellFrame = selectedCell?.frame ?? .zero
        
        var indicatorFrame = indicator.frame
        indicatorFrame.origin.x = selectedCellFrame.origin.x + 8
        indicatorFrame.size.width = selectedCellFrame.size.width - 16
        
        if animated {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.indicator.frame = indicatorFrame
            }
        } else {
            self.indicator.frame = indicatorFrame
        }
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PagerTabBarController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource else {
            fatalError("Datasource must not be nil")
        }
        
        guard dataSource.tabBarTitles(self).count == dataSource.viewControllers(self).count else {
            fatalError("The number of tab bars should be the same as the number of view controllers.")
        }
        
        return dataSource.tabBarTitles(self).count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource else {
            fatalError("Datasource must not be nil")
        }
    
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarItem.id, for: indexPath) as? TabBarItem else {
            return UICollectionViewCell()
        }
        
        cell.configuration.title = dataSource.tabBarTitles(self)[indexPath.row]
        cell.configuration.font = UIFont.systemFont(ofSize: 17)
        cell.configuration.selectedFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        cell.configuration.textColor = .lightGray
        
        return cell
    }
    
    
    /// 탭 선택 시 컬렉션뷰, 인디케이터, 스크롤뷰 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == tabBarCollectionView else { return }
        
        tabBarCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        updateIndicatorPosition(index: indexPath.row, animated: true)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            let offsetX = CGFloat(indexPath.row) * (self?.scrollView.frame.width ?? 0)
            self?.scrollView.contentOffset.x = offsetX
        }
    }
    
    
    /// 스크롤뷰 스크롤 시 컬렉션뷰, 인디케이터 이동
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
        let index = targetContentOffset.pointee.x / scrollView.frame.width
        let roundedIndex = Int(round(index))
        let indexPath = IndexPath(item: roundedIndex, section: 0)
        collectionView(tabBarCollectionView, didSelectItemAt: indexPath)
    }
    
}

// MARK: - CompositionalLayout

private extension PagerTabBarController {
    
    static func tabBarCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1))
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .absolute(80),
                    heightDimension: .fractionalHeight(1)),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        let configuration = layout.configuration
        configuration.scrollDirection = .horizontal
        layout.configuration = configuration
        return layout
    }
    
}
