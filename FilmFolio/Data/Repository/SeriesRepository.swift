//
//  SeriesRepository.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/09/23.
//

import Foundation
import RxSwift

protocol SeriesRepository {
    func trending() -> Observable<[Series]>
    func onTheAir() -> Observable<[Series]>
    func topRated() -> Observable<[Series]>
    func upcoming() -> Observable<[Upcoming]>
    func detail(_ id: Int) -> Observable<SeriesDetail>
    func search(query: String, page: Int) -> Observable<[Series]>
}

struct DefaultSeriesRepository: SeriesRepository {
    
    // MARK: Properties
    
    private let networkManager: NetworkManager
    
    
    // MARK: Initializing
    
    init(networkManager: NetworkManager = DefaultNetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    
    // MARK: Methods
    
    func trending() -> Observable<[Series]> {
        let endpoint = EndpointCollection.trendingSeries()
        return networkManager.request(endpoint)
            .map { (r: TMDBResponse) in r.results }
    }
    
    func onTheAir() -> Observable<[Series]> {
        let requests: [Observable<TMDBResponse<Series>>] = Array(1...4).map {
            let endpoint = EndpointCollection.topRatedSeries(page: $0)
            return networkManager.request(endpoint)
        }
        
        return Observable.combineLatest(requests)
            .map { $0.map { $0.results }.flatMap { $0 } }
            .map { $0.filter { $0.originCountry.isIntersect(with: ["KR", "US", "JP"]) } }
    }
    
    func topRated() -> Observable<[Series]> {
        let endpoint = EndpointCollection.topRatedSeries()
        return networkManager.request(endpoint)
            .map { (r: TMDBResponse) in r.results }
    }
    
    func upcoming() -> Observable<[Upcoming]> {
        let endpoint = EndpointCollection.upcomingSeries(date: Date.tomorrow())
        return networkManager.request(endpoint)
            .map { (r: TMDBResponse<Series>) in r.results }
            .map { $0.map { $0.toUpcoming() } }
            .map { $0.filter { $0.backdropPath != nil && !$0.overview.isEmpty } }
    }
    
    func detail(_ id: Int) -> Observable<SeriesDetail> {
        let endpoint = EndpointCollection.seriesDetail(id: id)
        return networkManager.request(endpoint)
    }
    
    func search(query: String, page: Int) -> Observable<[Series]> {
        let endpoint = EndpointCollection.searchSeries(query: query, page: page)
        return networkManager.request(endpoint)
            .map { (r: TMDBResponse) in r.results }
    }
    
}
