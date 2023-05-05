//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 18/2/23.
//

import Foundation

public final class RemoteFeedLoader {

	public typealias Result = LoadFeedResult<Error>

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
		client.get(from: url) { [weak self] result in
			guard self != nil else { return }
			switch result {
			case let .success(data, response):
				completion(FeedItemsMapper.map(data, response))
			case .failure:
				completion(.failure(.connectivity))
			}
		}
	}
}
