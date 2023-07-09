//
//  PerformanceXCTests.swift
//  FilmFolioUITests
//
//  Created by 신소민 on 2023/07/09.
//

import XCTest

final class PerformanceXCTests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testScrollingAnimationPerformance() throws {
        app.launch()
        let movieCollection = app.collectionViews.firstMatch

        let measureOptions = XCTMeasureOptions()
        measureOptions.invocationOptions = [.manuallyStop]
        
        measure(metrics: [XCTOSSignpostMetric.scrollingAndDecelerationMetric], options: measureOptions) {
            movieCollection.swipeLeft(velocity: .fast)
            stopMeasuring()
            movieCollection.swipeRight(velocity: .fast)
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
