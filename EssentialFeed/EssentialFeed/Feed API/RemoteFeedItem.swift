//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 25/6/23.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
