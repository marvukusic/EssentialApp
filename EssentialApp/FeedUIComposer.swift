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
    
    public static func feedComposedWith(feedLoader: @escaping () -> FeedLoader.Publisher, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)


        let feedViewController = FeedViewController.createWith(delegate: presentationAdapter,
                                                               title: FeedPresenter.title)
        
        let presenter = FeedPresenter(feedView: FeedViewAdapter(controller: feedViewController,
                                                                imageLoader: imageLoader),
                                      loadingView: WeakRefVirtualProxy(feedViewController),
                                      errorView: WeakRefVirtualProxy(feedViewController))
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
