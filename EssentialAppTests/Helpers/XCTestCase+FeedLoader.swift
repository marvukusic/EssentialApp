//
//  XCTestCase+FeedLoader.swift
//  EssentialAppTests
//
//  Created by Marko Vukušić on 23.01.2023..
//

import XCTest
import EssentialApp
import EssentialFeed

protocol FeedLoaderTestCase: XCTestCase {}

extension FeedLoaderTestCase {
//    func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file: StaticString = #file, line: UInt = #line) {
//        let exp = expectation(description: "Wait for load completion")
//        sut.load { receivedResult in
//            switch (receivedResult, expectedResult) {
//            case let (.success(receivedFeed), .success(expectedResult)):
//                XCTAssertEqual(expectedResult, receivedFeed)
//            case (.failure, .failure):
//                break
//            default:
//                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
//            }
//            exp.fulfill()
//        }
//        wait(for: [exp], timeout: 1)
//    }
}
