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
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if (value == key) {
            XCTFail("Missing localized string key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
