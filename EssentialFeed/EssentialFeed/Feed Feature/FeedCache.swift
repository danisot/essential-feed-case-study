//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 12/8/23.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
