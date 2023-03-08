//
//  FeedViewController+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Marko Vukušić on 28.09.2022.
//

import XCTest
import Foundation
import EssentialFeed

extension FeedUIIntegrationTests {
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {
        }
    }
    
    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }
    
    var feedTitle: String {
        FeedPresenter.title
    }
}
