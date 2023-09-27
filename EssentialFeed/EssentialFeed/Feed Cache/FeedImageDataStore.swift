//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 8/8/23.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
