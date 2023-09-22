//
//  SeriesHomeViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/07/06.
//

import Foundation
import RxSwift

struct SeriesHomeViewModel {
    
    // MARK: Input & Output
    
    struct Input {
        let fetchTrendingSeries: Observable<Void>
        let fetchOnTheAirSeries: Observable<Void>
        let fetchTopRatedSeries: Observable<Void>
    }
    
    struct Output {
        let trending: PublishSubject<[Series]>
        let onTheAir: PublishSubject<[Series]>
        let topRated: PublishSubject<[Series]>
    }
    
    
    // MARK: Properties
    
    private let repository: SeriesRepository
    private let trending = PublishSubject<[Series]>()
    private let onTheAir = PublishSubject<[Series]>()
    private let topRated = PublishSubject<[Series]>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(repository: SeriesRepository = DefaultSeriesRepository()) {
        self.repository = repository
    }
    
    
    // MARK: Methods
    
    func transform(_ input: SeriesHomeViewModel.Input) -> SeriesHomeViewModel.Output {
        
        input.fetchTrendingSeries
            .flatMap { repository.trending() }
            .catchAndReturn([])
            .bind(to: trending)
            .disposed(by: disposeBag)
        
        input.fetchOnTheAirSeries
            .flatMap { repository.onTheAir() }
            .catchAndReturn([])
            .bind(to: onTheAir)
            .disposed(by: disposeBag)
        
        input.fetchTopRatedSeries
            .flatMap { repository.topRated() }
            .catchAndReturn([])
            .bind(to: topRated)
            .disposed(by: disposeBag)
        
        return SeriesHomeViewModel.Output(
            trending: trending,
            onTheAir: onTheAir,
            topRated: topRated
        )
    }
    
}
