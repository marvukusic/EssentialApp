//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Marko Vukušić on 17.01.2023..
//

import UIKit
import CoreData
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("feed-store.sqlite")

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        configureWindow()
    }
    
    func configureWindow() {
        let remoteClient = makeRemoteClient()
        let coreDataFeedStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        
        let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        let localFeedLoader = LocalFeedLoader(store: coreDataFeedStore, currentDate: Date.init)
        let remoteFeedLoaderDecorator = FeedLoaderCacheDecorator(decoratee: remoteFeedLoader, cache: localFeedLoader)
        let feedLoaderComposite = FeedLoaderWithFallbackComposite(primary: remoteFeedLoaderDecorator, fallback: localFeedLoader)
        
        let localImageLoader = LocalFeedImageDataLoader(store: coreDataFeedStore)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        let remoteImageLoaderDecorator = FeedImageDataLoaderCacheDecorator(decoratee: remoteImageLoader, cache: localImageLoader)
        let imageLoaderComposite = FeedImageDataLoaderWithFallbackComposite(primary: localImageLoader, fallback: remoteImageLoaderDecorator)
        
        let feedViewController = FeedUIComposer.feedComposedWith(feedLoader: feedLoaderComposite, imageLoader: imageLoaderComposite)
        
        window?.rootViewController = UINavigationController(rootViewController: feedViewController)
    }
    
    func makeRemoteClient() -> HTTPClient {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
}
