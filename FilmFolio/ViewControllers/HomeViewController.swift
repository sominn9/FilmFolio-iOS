//
//  HomeViewController.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/05/09.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: Now Playing
    
    private lazy var nowPlayingCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout.carousel()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var nowPlayingDataSource: UICollectionViewDiffableDataSource<Int, Movie.ID>?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        view.backgroundColor = .white
        configureNowPlayingCollectionView()
        configureNowPlayingDataSource()
    }
}

// MARK: - Now Playing

private extension HomeViewController {
    
    func configureNowPlayingCollectionView() {
        view.addSubview(nowPlayingCollectionView)
        NSLayoutConstraint.activate([
            nowPlayingCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            nowPlayingCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            nowPlayingCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nowPlayingCollectionView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 50)
        ])
    }
    
    func configureNowPlayingDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CardCell, Movie> { cell, indexPath, itemIdentifier in
            cell.backgroundColor = .darkGray
        }
        
        nowPlayingDataSource = UICollectionViewDiffableDataSource(collectionView: nowPlayingCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            // TODO: item 파라미터 변경하기
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: nil)
        })
    }
}
