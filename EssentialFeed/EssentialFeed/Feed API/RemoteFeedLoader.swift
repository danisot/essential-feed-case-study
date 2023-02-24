//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 18/2/23.
//

import Foundation

public protocol HTTPClient {
	func get(from url: URL, completion: @escaping (URLResponse?, Error?) -> Void)
}

public final class RemoteFeedLoader {

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

	public func load(completion: @escaping (Error) -> Void) {
		client.get(from: url) { statusCode, error in
			if error != nil {
				completion(.connectivity)
			} else {
				completion(.invalidData)
			}
		}
	}
}
