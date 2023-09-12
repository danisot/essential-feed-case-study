//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 7/4/23.
//

import Foundation

public final class FeedItemsMapper {

	private struct Root: Decodable {
		private let items: [RemoteFeedItem]

        private struct RemoteFeedItem: Decodable {
            let id: UUID
            let description: String?
            let location: String?
            let image: URL
        }

        var images: [FeedImage] {
            items.map {
                FeedImage(
                    id: $0.id,
                    description: $0.description,
                    location: $0.location,
                    url: $0.image)
            }
        }
	}

    public enum Error: Swift.Error {
        case invalidData
    }

	public static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
			throw Error.invalidData
		}

        return root.images
	}
}
