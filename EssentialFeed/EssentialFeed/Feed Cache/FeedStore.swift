//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 23/6/23.
//

import Foundation


public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    func deleteCachedFeed() throws
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    func retrieve() throws -> CachedFeed?
}
