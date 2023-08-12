//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 12/8/23.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
