//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 18/2/23.
//

import Foundation

public protocol HTTPClient {
	func get(from url: URL, completion: @escaping (Error) -> Void)
}

public final class RemoteFeedLoader {

	public enum Error: Swift.Error {
		case connectivity
	}

	private let client: HTTPClient
	private let url: URL

	public init(client: HTTPClient, url: URL) {
		self.client = client
		self.url = url
	}

	public func load(completion: @escaping (Error) -> Void) {
		client.get(from: url) { error in
			completion(.connectivity)
		}
	}
}
