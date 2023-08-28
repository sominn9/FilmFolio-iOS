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
            .map { (r: TMDBResponse) in r.results }
            .catchAndReturn([])
            .bind(to: trending)
            .disposed(by: disposeBag)
        
        input.fetchOnTheAirSeries
            .map { Array(1...4).map { EndpointCollection.onTheAirSeries(page: $0) } }
            .map { (endpoints: [Endpoint]) -> [Observable<TMDBResponse>] in
                endpoints.map { e in networkManager.request(e) }
            }
            .flatMap { Observable.combineLatest($0) }
            .map { $0.map { $0.results }.flatMap { $0 } }
            .map { $0.filter { $0.originCountry.isIntersect(with: ["KR", "US", "JP"]) } }
            .catchAndReturn([])
            .bind(to: onTheAir)
            .disposed(by: disposeBag)
        
        input.fetchTopRatedSeries
            .map { EndpointCollection.topRatedSeries() }
            .flatMap { networkManager.request($0) }
            .map { (r: TMDBResponse) in r.results }
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
