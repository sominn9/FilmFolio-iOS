//
//  UpcomingViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/17.
//

import Foundation
import RxSwift

struct UpcomingViewModel {
    
    // MARK: Input & Output
    
    struct Input {
        let fetchUpcomings: Observable<Void>
    }
    
    struct Output {
        let upcomings: Observable<[Upcoming]>
    }
    
    
    // MARK: Properties
    
    private let networkManager: NetworkManager
    private let movieRepository: MovieRepository
    private let disposeBag = DisposeBag()
    private let upcomings = PublishSubject<[Upcoming]>()
    
    
    // MARK: Initializing
    
    init(
        networkManager: NetworkManager = DefaultNetworkManager.shared,
        movieRepository: MovieRepository = DefaultMovieRepository()
    ) {
        self.networkManager = networkManager
        self.movieRepository = movieRepository
    }
    
    
    // MARK: Methods
    
    func transform(_ input: UpcomingViewModel.Input) -> UpcomingViewModel.Output {
        
        input.fetchUpcomings
            .flatMap { movieRepository.upcoming() }
            .subscribe(onNext: { upcomings.onNext($0) })
            .disposed(by: disposeBag)
        
        input.fetchUpcomings
            .map { EndpointCollection.upcomingSeries(date: Date.tomorrow()) }
            .flatMap { networkManager.request($0) }
            .map { (r: TMDBResponse<Series>) in r.results }
            .map { $0.map { $0.toUpcoming() } }
            .map { $0.filter { $0.backdropPath != nil && !$0.overview.isEmpty } }
            .subscribe(onNext: { upcomings.onNext($0) })
            .disposed(by: disposeBag)
        
        return UpcomingViewModel.Output(upcomings: upcomings)
    }
    
}
