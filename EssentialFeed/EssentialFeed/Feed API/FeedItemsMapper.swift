//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 7/4/23.
//

import Foundation

final class FeedItemsMapper {

	private struct Root: Decodable {
		let items: [Item]

		var feed: [FeedItem] {
			items.map { $0.item }
		}
	}

	private struct Item: Decodable {
		let id: UUID
		let description: String?
		let location: String?
		let image: URL

		var item: FeedItem {
			FeedItem(
				id: id,
				description: description,
				location: location,
				imageURL: image
			)
		}
	}

	private static let OK_200 = 200

	static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
		guard response.statusCode == OK_200,
			  let root = try? JSONDecoder().decode(Root.self, from: data)
		else {
			return .failure(.invalidData)
		}

		return .success(root.feed)
	}
}
