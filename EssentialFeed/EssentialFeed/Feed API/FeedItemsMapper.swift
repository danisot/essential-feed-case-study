//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 7/4/23.
//

import Foundation

internal final class FeedItemsMapper {

	private struct Root: Decodable {
		let items: [RemoteFeedItem]
	}

	private static let OK_200 = 200

	internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedItem] {
		guard
            response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data)
		else {
			throw RemoteFeedLoader.Error.invalidData
		}

        return root.items
	}
}
