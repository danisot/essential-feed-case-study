//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by José Daniel Fernández Sotelo on 10/8/23.
//

import Foundation
import EssentialFeed

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
    [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}
