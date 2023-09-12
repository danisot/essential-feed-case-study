//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by José Daniel Fernández Sotelo on 29/6/23.
//

import Foundation

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    NSError(domain: "anyError", code: 1)
}

func anyData() -> Data {
    Data("any data".utf8)
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json = ["items": items]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
