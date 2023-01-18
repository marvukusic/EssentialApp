//
//  FeedLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Marko Vukušić on 18.01.2023..
//

import Foundation
import EssentialFeed

public class FeedLoaderWithFallbackComposite: FeedLoader {
    let primary: FeedLoader
    let fallback: FeedLoader
    
    public init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        primary.load { [fallback] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                fallback.load { result in
                    completion(result)
                }
            }
        }
    }
}
