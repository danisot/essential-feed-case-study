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
