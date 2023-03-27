//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Marko Vukušić on 27.03.2023..
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import Combine

final public class CommentsUIComposer {
    private init() {}
    
    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>
    
    public static func commentsComposedWith(commentsLoader: @escaping () -> AnyPublisher<[FeedImage], Error>) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: commentsLoader)
        
        let feedViewController = ListViewController.createWith(title: ImageCommentsPresenter.title)
        feedViewController.onRefresh = presentationAdapter.loadResource
        
        let presenter = LoadResourcePresenter(resourceView: FeedViewAdapter(controller: feedViewController, imageLoader: { _ in Empty<Data, Error>().eraseToAnyPublisher() }),
                                              loadingView: WeakRefVirtualProxy(feedViewController),
                                              errorView: WeakRefVirtualProxy(feedViewController),
                                              mapper: FeedPresenter.map)
        presentationAdapter.presenter = presenter
        return feedViewController
    }
}

private extension ListViewController {
    static func createWith(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedViewController = storyboard.instantiateInitialViewController() as! ListViewController
        feedViewController.title = title
        return feedViewController
    }
}
