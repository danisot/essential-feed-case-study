//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 5/7/23.
//

import Foundation

public final class CoreDataFeedStore: FeedStore {

    public init() {}

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {

    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {

    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}
