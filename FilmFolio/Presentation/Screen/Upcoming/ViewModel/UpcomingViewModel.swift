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
    
    private let movieRepository: MovieRepository
    private let seriesRepository: SeriesRepository
    private let disposeBag = DisposeBag()
    private let upcomings = PublishSubject<[Upcoming]>()
    
    
    // MARK: Initializing
    
    init(
        movieRepository: MovieRepository = DefaultMovieRepository(),
        seriesRepository: SeriesRepository = DefaultSeriesRepository()
    ) {
        self.movieRepository = movieRepository
        self.seriesRepository = seriesRepository
    }
    
    
    // MARK: Methods
    
    func transform(_ input: UpcomingViewModel.Input) -> UpcomingViewModel.Output {
        
        input.fetchUpcomings
            .flatMap { movieRepository.upcoming() }
            .bind(to: upcomings)
            .disposed(by: disposeBag)
        
        input.fetchUpcomings
            .flatMap { seriesRepository.upcoming() }
            .bind(to: upcomings)
            .disposed(by: disposeBag)
        
        return UpcomingViewModel.Output(upcomings: upcomings)
    }
    
}
