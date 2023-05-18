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
    
    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>
    
    public static func feedComposedWith(feedLoader: @escaping () -> AnyPublisher<Paginated<FeedImage>, Error>,
                                        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
                                        selection: @escaping (FeedImage) -> Void = { _ in }) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: feedLoader)

        let feedViewController = makeFeedViewController(title: FeedPresenter.title)
        feedViewController.onRefresh = presentationAdapter.loadResource
        
        let presenter = LoadResourcePresenter(resourceView: FeedViewAdapter(controller: feedViewController, imageLoader: imageLoader, selection: selection),
                                              loadingView: WeakRefVirtualProxy(feedViewController),
                                              errorView: WeakRefVirtualProxy(feedViewController))
        presentationAdapter.presenter = presenter
        return feedViewController
    }
    
    private static func makeFeedViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedViewController = storyboard.instantiateInitialViewController() as! ListViewController
        feedViewController.title = title
        return feedViewController
    }
}
