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
    
    private let networkManager: NetworkManager
    private let trending = PublishSubject<[Series]>()
    private let onTheAir = PublishSubject<[Series]>()
    private let topRated = PublishSubject<[Series]>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    
    // MARK: Methods
    
    func transform(_ input: SeriesHomeViewModel.Input) -> SeriesHomeViewModel.Output {
        
        input.fetchTrendingSeries
            .map { EndpointCollection.trendingSeries() }
            .flatMap { networkManager.request($0) }
            .map { (r: SeriesResponse) in r.series }
            .catchAndReturn([])
            .bind(to: trending)
            .disposed(by: disposeBag)
        
        input.fetchOnTheAirSeries
            .map { EndpointCollection.onTheAirSeries() }
            .flatMap { networkManager.request($0) }
            .map { (r: SeriesResponse) in r.series }
            .map { $0.filter { $0.originCountry.isIntersect(with: ["KR", "US", "JP"]) } } // TODO: 언어에 따라 변경
            .catchAndReturn([])
            .bind(to: onTheAir)
            .disposed(by: disposeBag)
        
        input.fetchTopRatedSeries
            .map { EndpointCollection.topRatedSeries() }
            .flatMap { networkManager.request($0) }
            .map { (r: SeriesResponse) in r.series }
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
