//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Marko Vukušić on 14.09.2022.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import Combine

final public class FeedUIComposer {
    private init() {}
    
    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>
    
    public static func feedComposedWith(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> FeedViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: feedLoader)

        let feedViewController = FeedViewController.createWith(delegate: presentationAdapter,
                                                               title: FeedPresenter.title)
        
        let presenter = LoadResourcePresenter(resourceView: FeedViewAdapter(controller: feedViewController, imageLoader: imageLoader),
                                              loadingView: WeakRefVirtualProxy(feedViewController),
                                              errorView: WeakRefVirtualProxy(feedViewController),
                                              mapper: FeedPresenter.map)
        presentationAdapter.presenter = presenter
        return feedViewController
    }
}

private extension FeedViewController {
    static func createWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedViewController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedViewController.delegate = delegate
        feedViewController.title = title
        return feedViewController
    }
}
