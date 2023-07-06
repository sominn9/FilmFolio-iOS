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
        let fetchOnTheAirSeries: Observable<Void>
        let fetchPopularSeries: Observable<Void>
        let fetchTopRatedSeries: Observable<Void>
    }
    
    struct Output {
        let onTheAir: PublishSubject<[Series]>
        let popular: PublishSubject<[Series]>
        let topRated: PublishSubject<[Series]>
    }
    
    
    // MARK: Properties
    
    private let networkManager: NetworkManager
    private let onTheAir = PublishSubject<[Series]>()
    private let popular = PublishSubject<[Series]>()
    private let topRated = PublishSubject<[Series]>()
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    
    // MARK: Methods
    
    func transform(_ input: SeriesHomeViewModel.Input) -> SeriesHomeViewModel.Output {
        
        input.fetchOnTheAirSeries
            .map { EndpointCollection.onTheAirSeries() }
            .flatMap { networkManager.request($0) }
            .map { (r: SeriesResponse) in r.series }
            .map { $0.filter { $0.originCountry.isIntersect(with: ["KR"]) } } // TODO: 언어에 따라 변경
            .catchAndReturn([])
            .bind(to: onTheAir)
            .disposed(by: disposeBag)
        
        input.fetchPopularSeries
            .map { EndpointCollection.popularSeries() }
            .flatMap { networkManager.request($0) }
            .map { (r: SeriesResponse) in r.series }
            .map { $0.filter { $0.originCountry.isIntersect(with: ["KR", "US", "JP"]) } }
            .catchAndReturn([])
            .bind(to: popular)
            .disposed(by: disposeBag)
        
        input.fetchTopRatedSeries
            .map { EndpointCollection.topRatedSeries() }
            .flatMap { networkManager.request($0) }
            .map { (r: SeriesResponse) in r.series }
            .catchAndReturn([])
            .bind(to: topRated)
            .disposed(by: disposeBag)
        
        return SeriesHomeViewModel.Output(
            onTheAir: onTheAir,
            popular: popular,
            topRated: topRated
        )
    }
    
}
