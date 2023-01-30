//
//  WeakRefVirtualProxy.swift
//  EssentialFeediOS
//
//  Created by Marko Vukušić on 30.01.2023..
//

import EssentialFeed
import UIKit

final public class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    public init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    public func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    public func display(_ model: FeedImageViewModel<UIImage>) {
        object?.display(model)
    }
}

extension WeakRefVirtualProxy: FeedErrorView where T: FeedErrorView {
    public func display(_ viewModel: FeedErrorViewModel) {
        object?.display(viewModel)
    }
}
