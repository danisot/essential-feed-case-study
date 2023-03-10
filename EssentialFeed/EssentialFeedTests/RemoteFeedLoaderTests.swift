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

		sut.load()

		XCTAssertEqual(client.requestedURLs, [url])
	}

	func test_loadTwice_requestDataFromURLTwice() {
		let url = URL(string: "https://a-given-url.com")!
		let (sut, client) = makeSUT(url: url)

		sut.load()
		sut.load()

		XCTAssertEqual(client.requestedURLs, [url, url])
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
		var requestedURLs: [URL] = []

		func get(from url: URL) {
			requestedURLs.append(url)
		}
	}
}
