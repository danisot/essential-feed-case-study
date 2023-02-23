//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by José Daniel Fernández Sotelo on 18/2/23.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {

	func test_init_doesNotRequestDataFromURL() {
		let (_, client) = makeSUT()

		XCTAssertTrue(client.requestedURLs.isEmpty)
	}

	func test_load_requestDataFromURL() {
		let url = URL(string: "https://a-given-url.com")!
		let (sut, client) = makeSUT(url: url)

		sut.load { _ in }

		XCTAssertEqual(client.requestedURLs, [url])
	}

	func test_loadTwice_requestDataFromURLTwice() {
		let url = URL(string: "https://a-given-url.com")!
		let (sut, client) = makeSUT(url: url)

		sut.load { _ in }
		sut.load { _ in }
		
		XCTAssertEqual(client.requestedURLs, [url, url])
	}

	func test_load_deliversErrorOnClientError() {
		let (sut, client) = makeSUT()
		var capturedErrors: [RemoteFeedLoader.Error] = []

		let clientError = NSError(domain: "ClientError", code: 1)

		sut.load { error in
			capturedErrors.append(error)
		}
		client.complete(with: clientError)

		XCTAssertEqual(capturedErrors, [.connectivity])
	}

	// MARK: - Helpers

	private func makeSUT(
		url: URL = URL(string: "https://any-url.com")!
	) -> (RemoteFeedLoader, HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteFeedLoader(client: client, url: url)

		return (sut, client)
	}

	private class HTTPClientSpy: HTTPClient {
		var messages: [(url: URL, completion: (Error) -> Void)] = []
		var requestedURLs: [URL] {
			messages.map { $0.url }
		}

		func get(from url: URL, completion: @escaping (Error) -> Void) {
			messages.append((url, completion))
		}

		func complete(with error: Error, at index: Int = 0) {
			messages[index].completion(error)
		}
	}
}
