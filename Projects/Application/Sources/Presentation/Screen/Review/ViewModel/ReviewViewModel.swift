//
//  ReviewViewModel.swift
//  FilmFolio
//
//  Created by 신소민 on 2023/08/22.
//

import Foundation
import RxSwift

final class ReviewViewModel {
    
    // MARK: Input & Output
    
    struct Input {
        var text: Observable<String>
        var saveButtonPressed: Observable<Void>
    }
    
    struct Output {
        var title: Observable<String>
        var content: Observable<String>
        var posterURL: Observable<URL?>
    }
    
    
    // MARK: Properties
    
    @Inject private var saveReviewRepository: SaveReviewRepository
    private var review: Review
    private let disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(review: Review) {
        self.review = review
    }
    
    
    // MARK: Methods
    
    func transform(_ input: Input) -> Output {
        
        input.text
            .skip(1)
            .subscribe(with: self, onNext: { owner, text in
                owner.review.content = text
            })
            .disposed(by: disposeBag)
            
        input.saveButtonPressed
            .subscribe(with: self, onNext: { owner, _ in
                Task {
                    try await owner.saveReviewRepository.save(owner.review)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            title: Observable.just(review.title),
            content: Observable.just(review.content),
            posterURL: Observable.just(review.posterURL)
        )
    }
    
}
