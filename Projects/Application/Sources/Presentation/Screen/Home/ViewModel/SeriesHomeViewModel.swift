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
        let fetchSeries: Observable<Void>
    }
    
    struct Output {
        let trending: BehaviorSubject<[Series]>
        let onTheAir: BehaviorSubject<[Series]>
        let topRated: BehaviorSubject<[Series]>
    }
    
    
    // MARK: Properties
    
    @Inject private var repository: SeriesRepository
    private let disposeBag = DisposeBag()
    
    
    // MARK: Methods
    
    func transform(_ input: Input) -> Output {
        let trending = BehaviorSubject<[Series]>(value: [])
        let onTheAir = BehaviorSubject<[Series]>(value: [])
        let topRated = BehaviorSubject<[Series]>(value: [])
        
        input.fetchSeries
            .flatMap { repository.trending() }
            .catchAndReturn([])
            .subscribe(onNext: {
                trending.onNext($0)
            })
            .disposed(by: disposeBag)
        
        input.fetchSeries
            .flatMap { repository.onTheAir() }
            .catchAndReturn([])
            .subscribe(onNext: {
                onTheAir.onNext($0)
            })
            .disposed(by: disposeBag)
        
        input.fetchSeries
            .flatMap { repository.topRated() }
            .catchAndReturn([])
            .subscribe(onNext: {
                topRated.onNext($0)
            })
            .disposed(by: disposeBag)
        
        return SeriesHomeViewModel.Output(
            trending: trending,
            onTheAir: onTheAir,
            topRated: topRated
        )
    }
    
}
