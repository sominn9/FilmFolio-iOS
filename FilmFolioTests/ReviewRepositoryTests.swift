//
//  ReviewRepositoryTests.swift
//  FilmFolioTests
//
//  Created by 신소민 on 2023/08/29.
//

import XCTest
@testable import FilmFolio

final class ReviewRepositoryTests: XCTestCase {
    
    var repository: ReviewRepository!
    
    override func setUpWithError() throws {
        repository = DefaultReviewRepository(
            dataSource: CoreDataStorage(name: "Model", storeType: .inMemory)
        )
    }

    override func tearDownWithError() throws {
        
    }
    
    func test_리뷰_저장() async throws {
        
        // given
        let review = Review(id: 1, media: .movie, title: "", content: "", posterPath: nil, publishDate: "2022-03-11")
        
        // when
        try await repository.save(review)
        let fetchResult = try await repository.fetch(review.id, review.media)
        
        // then
        let unwrapped = try XCTUnwrap(fetchResult)
        XCTAssertEqual(unwrapped.id, review.id)
    }
    
    func test_리뷰_업데이트() async throws {
        
        // given
        var review = Review(id: 1, media: .movie, title: "", content: "", posterPath: nil, publishDate: "2022-03-11")
        try await repository.save(review)
        review.title = "new title"
        review.content = "new content"
        
        // when
        try await repository.update(review)
        let fetchResult = try await repository.fetch(review.id, review.media)
        
        // then
        let unwrapped = try XCTUnwrap(fetchResult)
        XCTAssertEqual(unwrapped.title, "new title")
        XCTAssertEqual(unwrapped.content, "new content")
    }
    
    func test_리뷰_삭제() async throws {
        
        // given
        let review = Review(id: 1, media: .movie, title: "", content: "", posterPath: nil, publishDate: "2022-03-11")
        try await repository.save(review)
        
        // when
        try await repository.delete(review)
        let fetchResult = try await repository.fetch(review.id, review.media)
        
        // then
        XCTAssertNil(fetchResult)
    }
    
}
