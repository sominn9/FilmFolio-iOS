//
//  ReviewListViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/31.
//

import Foundation
import RxCocoa
import RxSwift

final class ReviewListViewModel {
    
    // MARK: Input & Output
    
    struct Input {
        let fetchReviews: Observable<Void>
    }
    
    struct Output {
        let reviewList: Observable<[Review]>
    }
    
    
    // MARK: Properties
    
    private let reviewRepository: ReviewRepository
    private let disposeBag = DisposeBag()
    private var offset: Int = 0
    private let limit: Int = 10
    
    
    // MARK: Initializing
    
    init(reviewRepository: ReviewRepository = DefaultReviewRepository()) {
        self.reviewRepository = reviewRepository
    }
    
    
    // MARK: Methods
    
    func transform(_ input: Input) -> Output {
        
        let reviewList = PublishSubject<[Review]>()
        
        input.fetchReviews
            .delay(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler(queue: .global()))
            .subscribe(with: self, onNext: { owner, _ in
                Task {
                    let list = try await owner.reviewRepository.fetch(
                        offset: owner.offset,
                        count: owner.limit
                    )
                    // owner.offset += list.count
                    reviewList.onNext(list)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(reviewList: reviewList)
    }
    
}
