//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 18/2/23.
//

import Foundation

public final class RemoteFeedLoader {

	public enum Result: Equatable {
		case success([FeedItem])
		case failure(Error)
	}

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	private let client: HTTPClient
	private let url: URL

	public init(client: HTTPClient, url: URL) {
		self.client = client
		self.url = url
	}

	public func load(completion: @escaping (Result) -> Void) {
		client.get(from: url) { result in
			switch result {
			case let .success(data, response):
				do {
					let items = try FeedItemsMapper.map(data, response)
					completion(.success(items))
				} catch {
					completion(.failure(.invalidData))
				}
			case .failure:
				completion(.failure(.connectivity))
			}
		}
	}
}

private class FeedItemsMapper {

	struct Root: Decodable {
		let items: [Item]
	}

	struct Item: Decodable {
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

	static let OK_200 = 200

	static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
		guard response.statusCode == OK_200 else {
			throw RemoteFeedLoader.Error.invalidData
		}
		return try JSONDecoder().decode(Root.self, from: data).items.map { $0.item }
	}
}

