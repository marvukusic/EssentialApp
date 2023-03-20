//
//  ListViewController+LoaderSpy.swift
//  EssentialFeediOSTests
//
//  Created by Marko Vukušić on 28.09.2022.
//

import EssentialFeed
import EssentialFeediOS
import Combine

class LoaderSpy: FeedImageDataLoader {
    // MARK: - Feed loader
    private var feedRequests = [PassthroughSubject<[FeedImage], Error>]()
    
    var loadFeedCallCount: Int { feedRequests.count }
    
    func loadPublisher() -> AnyPublisher<[FeedImage], Error> {
        let publisher = PassthroughSubject<[FeedImage], Error>()
        feedRequests.append(publisher)
        return publisher.eraseToAnyPublisher()
    }
    
    func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
        feedRequests[index].send(feed)
    }
    
    func completeFeedLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "Any error", code: 0)
        feedRequests[index].send(completion: .failure(error))
    }
    
    // MARK: - Image loader
    private var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
    
    var loadedImageURLs: [URL] {
        imageRequests.map { $0.url }
    }
    
    private(set) var cancelledImageURLs = [URL]()
    
    private struct TaskSpy: FeedImageDataLoaderTask {
        var cancelCallback: () -> Void
        
        func cancel() {
            cancelCallback()
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> FeedImageDataLoaderTask {
        imageRequests.append((url: url, completion: completion))
        
        return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
    }
    
    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].completion(.success(imageData))
    }
    
    func completeImageLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "Any error", code: 0)
        imageRequests[index].completion(.failure(error))
    }
}
