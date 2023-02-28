//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Marko Vukušić on 30.01.2023..
//

import EssentialFeed
import EssentialFeediOS
import Combine

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    let feedLoader: () -> AnyPublisher<[FeedImage], Error>
    private var cancellable: Cancellable?
    var presenter: FeedPresenter?
    
    init(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        
        cancellable = feedLoader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break
                        
                    case let .failure(error):
                        self?.presenter?.didFinishLoadingFeed(with: error)
                    }
                }, receiveValue: { [weak self] feed in
                    self?.presenter?.didFinishLoadingFeed(feed: feed)
                })
    }
}
