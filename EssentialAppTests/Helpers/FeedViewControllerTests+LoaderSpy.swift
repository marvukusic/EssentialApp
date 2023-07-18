//
//  ListViewController+LoaderSpy.swift
//  EssentialFeediOSTests
//
//  Created by Marko Vukušić on 28.09.2022.
//

import EssentialFeed
import EssentialFeediOS
import Combine

extension FeedUIIntegrationTests {
    class LoaderSpy {
        
        // MARK: - Feed loader
        
        private var feedRequests = [PassthroughSubject<Paginated<FeedImage>, Error>]()
        
        var loadFeedCallCount: Int { feedRequests.count }
        
        func loadPublisher() -> AnyPublisher<Paginated<FeedImage>, Error> {
            let publisher = PassthroughSubject<Paginated<FeedImage>, Error>()
            feedRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            feedRequests[index].send(Paginated(items: feed, loadMorePublisher: { [weak self] in
                self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
            }))
            feedRequests[index].send(completion: .finished)
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            feedRequests[index].send(completion: .failure(anyNSError()))
        }
        
        // MARK: - LoadMoreFeedLoader
        
        private var loadMoreRequests = [PassthroughSubject<Paginated<FeedImage>, Error>]()
        var loadMoreCallCount: Int { loadMoreRequests.count }
        
        func loadMorePublisher() -> AnyPublisher<Paginated<FeedImage>, Error> {
            let publisher = PassthroughSubject<Paginated<FeedImage>, Error>()
            loadMoreRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeLoadMore(with feed: [FeedImage] = [], lastPage: Bool = false, at index: Int = 0) {
            loadMoreRequests[index].send(Paginated(items: feed, loadMorePublisher: lastPage ? nil : { [weak self] in
                self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
            }))
        }
        
        func completeLoadMoreWithError(at index: Int = 0) {
            loadMoreRequests[index].send(completion: .failure(anyNSError()))
        }
        
        // MARK: - Image loader
        
        
        var loadedImageURLs: [URL] {
            imageRequests.map { $0.url }
        }
        
        private(set) var cancelledImageURLs = [URL]()
        
        private var imageRequests = [(url: URL, publisher: PassthroughSubject<Data, Error>)]()
        
        func loadImageDataPublisher(from url: URL) -> AnyPublisher<Data, Error> {
            let publisher = PassthroughSubject<Data, Error>()
            imageRequests.append((url, publisher))
            return publisher.handleEvents(receiveCancel: { [weak self] in
                self?.cancelledImageURLs.append(url)
            }).eraseToAnyPublisher()
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].publisher.send(imageData)
            imageRequests[index].publisher.send(completion: .finished)
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            imageRequests[index].publisher.send(completion: .failure(anyNSError()))
        }
    }
}
