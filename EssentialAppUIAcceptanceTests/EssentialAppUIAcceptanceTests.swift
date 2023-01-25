//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Marko Vukušić on 25.01.2023..
//

import XCTest

final class EssentialAppUIAcceptanceTests: XCTestCase {

//    func test_onLaunch_displayRemoteFeedWhenCustomerHasConnectivity() {
//        let app = XCUIApplication()
//
//        app.launch()
//
//        XCTAssertEqual(app.cells.count, 22)
//        XCTAssertEqual(app.cells.firstMatch.images.count, 1)
//    }
    
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        
        app.launch()

        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(feedCells.count, 22)

        let firstImage = app.images.matching(identifier: "feed-image-view").firstMatch
        XCTAssertTrue(firstImage.exists)
    }
}
