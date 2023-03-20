//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 18/2/23.
//

import Foundation

public enum HTTPClientResult {
	case success(Data, HTTPURLResponse)
	case failure(Error)
}

public protocol HTTPClient {
	func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

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
			case let .success(data, _):
				if let _ = try? JSONSerialization.jsonObject(with: data) {
					completion(.success([]))
				} else {
					completion(.failure(.invalidData))
				}
			case .failure:
				completion(.failure(.connectivity))
			}
		}
	}
}
