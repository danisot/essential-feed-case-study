//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 14/8/23.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
