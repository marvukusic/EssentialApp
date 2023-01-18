//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Marko Vukušić on 16.08.2022.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "https://a-url.com")!
}

func uniqueData() -> Data {
    return Data("\(UUID())".utf8)
}
