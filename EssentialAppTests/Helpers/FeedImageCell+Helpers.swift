//
//  FeedImageCell+Helpers.swift
//  EssentialFeediOSTests
//
//  Created by Marko Vukušić on 28.09.2022.
//

import UIKit
import EssentialFeediOS

extension FeedImageCell {
    var isShowingLocation: Bool { !locationContainer.isHidden }
    var descriptionText: String? { descriptionLabel.text }
    var locationText: String? { locationLabel.text }
    var isShowingLoadingIndicator: Bool { feedImageContainer.isShimmering }
    var renderedImage: Data? { feedImageView.image?.pngData() }
    var isShowingRetryAction: Bool { !feedImageRetryButton.isHidden }
    func simulateRetryAction() { feedImageRetryButton.simulateTap() }
}
