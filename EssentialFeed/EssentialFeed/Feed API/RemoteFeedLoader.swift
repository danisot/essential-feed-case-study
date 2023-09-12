//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 18/2/23.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(client: HTTPClient, url: URL) {
        self.init(client: client, url: url, mapper: FeedItemsMapper.map)
    }
}
