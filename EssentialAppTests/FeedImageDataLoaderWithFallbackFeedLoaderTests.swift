//
//  FeedImageDataLoaderWithFallbackFeedLoaderTests.swift
//  EssentialAppTests
//
//  Created by Marko Vukušić on 18.01.2023..
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    let primary: FeedImageDataLoader
    let fallback: FeedImageDataLoader
    
    init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> EssentialFeed.FeedImageDataLoaderTask {
        _ = primary.loadImageData(from: url, completion: completion)
        return Task()
    }
    
    private class Task: FeedImageDataLoaderTask {
        func cancel() {
        }
    }
}

final class FeedImageDataLoaderWithFallbackFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotLoadImageData() {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        _ = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        XCTAssertTrue(primaryLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    func test_loadImageData_loadsFromPrimaryLoaderFirst() {
        let url = anyURL()
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected to load URL from primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }

//    func test_loadImageData_loadsFromPrimaryLoaderFirst() {
//        let primaryImageData = uniqueData()
//        let fallbackImageData = uniqueData()
//
//        let primaryLoader = LoaderSpy(result: .success(primaryImageData))
//        let fallbackLoader = LoaderSpy(result: .success(fallbackImageData))
//
//        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
//
//        let exp = expectation(description: "Wait for load completion")
//        _ = sut.loadImageData(from: anyURL()) { result in
//            switch result {
//            case .success(let data):
//                XCTAssertEqual(primaryImageData, data)
//            case .failure:
//                XCTFail("Expected success response, got \(result) instead")
//            }
//            exp.fulfill()
//        }
//        wait(for: [exp], timeout: 1)
//    }
    
    // MARK: - Helpers
    
    class LoaderSpy: FeedImageDataLoader {
        private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        
        var loadedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        private struct Task: FeedImageDataLoaderTask {
            func cancel() {}
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            return Task()
        }
    }
}
