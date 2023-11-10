//
//  RepositoryAssembly.swift
//  FilmFolio
//
//  Created by 신소민 on 10/30/23.
//

import Swinject

final class RepositoryAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(ReviewRepository.self) { resolver in
            guard let dataSource = resolver.resolve(CoreDataStorage.self) else {
                fatalError("Could not retrieve the CoreDataStorage instance.")
            }
            return DefaultReviewRepository(dataSource: dataSource)
        }
        
        container.register(SaveReviewRepository.self) { resolver in
            guard let reviewRepository = resolver.resolve(ReviewRepository.self) else {
                fatalError("Could not retrieve the ReviewRepository instance.")
            }
            return DefaultSaveReviewRepository(reviewRepository: reviewRepository)
        }
        
        container.register(LoadReviewRepository.self) { resolver in
            guard let reviewRepository = resolver.resolve(ReviewRepository.self) else {
                fatalError("Could not retrieve the ReviewRepository instance.")
            }
            return DefaultLoadReviewRepository(reviewRepository: reviewRepository)
        }
        
        container.register(MovieRepository.self) { resolver in
            guard let networkManager = resolver.resolve(NetworkManager.self) else {
                fatalError("Could not retrieve the NetworkManager instance.")
            }
            return DefaultMovieRepository(networkManager: networkManager)
        }
        
        container.register(SeriesRepository.self) { resolver in
            guard let networkManager = resolver.resolve(NetworkManager.self) else {
                fatalError("Could not retrieve the NetworkManager instance.")
            }
            return DefaultSeriesRepository(networkManager: networkManager)
        }
    }
    
}
