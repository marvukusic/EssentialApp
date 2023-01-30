//
//  FeedViewController+Assertions.swift
//  EssentialFeediOSTests
//
//  Created by Marko Vukušić on 28.09.2022.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

extension FeedUIIntegrationTests {
    func assertThat(_ sut: FeedViewController, hsViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedImageView(at: index)
        
        guard let cell = view else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead")
        }
        
        let shouldLocationBeVisible = image.location != nil
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, file: file, line: line)
        XCTAssertEqual(cell.descriptionText, image.description, file: file, line: line)
        XCTAssertEqual(cell.locationText, image.location, file: file, line: line)
    }
    
    func assertThat(_ sut: FeedViewController, isRendering feed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), feed.count, file: file, line: line)
        
        feed.enumerated().forEach { index, image in
            assertThat(sut, hsViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }
}
