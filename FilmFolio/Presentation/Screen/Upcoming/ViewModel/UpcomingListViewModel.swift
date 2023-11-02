//
//  UpcomingListViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/17.
//

import Foundation
import RxSwift

struct UpcomingListViewModel {
    
    // MARK: Input & Output
    
    struct Input {
        let fetchUpcomings: Observable<Void>
    }
    
    struct Output {
        let upcomings: Observable<[Upcoming]>
    }
    
    
    // MARK: Properties
    
    @Inject private var movieRepository: MovieRepository
    @Inject private var seriesRepository: SeriesRepository
    private let upcomings = PublishSubject<[Upcoming]>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Methods
    
    func transform(_ input: Input) -> Output {
        
        input.fetchUpcomings
            .flatMap { movieRepository.upcoming() }
            .bind(to: upcomings)
            .disposed(by: disposeBag)
        
        input.fetchUpcomings
            .flatMap { seriesRepository.upcoming() }
            .bind(to: upcomings)
            .disposed(by: disposeBag)
        
        return Output(upcomings: upcomings)
    }
    
}
