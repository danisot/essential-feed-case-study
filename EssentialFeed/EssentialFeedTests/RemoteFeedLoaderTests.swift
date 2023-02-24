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

		sut.load { capturedErrors.append($0) }
		client.complete(with: clientError)

		XCTAssertEqual(capturedErrors, [.connectivity])
	}

	func test_load_deliversErrorOnNon200HTTPResponseCode() {
		let (sut, client) = makeSUT()
		let invalidStatusCodes = [199, 201, 346, 404, 500]

		invalidStatusCodes.enumerated().forEach { index, code in
			var capturedErrors: [RemoteFeedLoader.Error] = []

			sut.load { capturedErrors.append($0) }
			client.complete(statusCode: code, at: index)

			XCTAssertEqual(capturedErrors, [.invalidData])
		}
	}

	func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
		let (sut, client) = makeSUT()
		let invalidJSON = Data("invalid data representation".utf8)
		var capturedError: [RemoteFeedLoader.Error] = []

		sut.load { capturedError.append($0) }
		client.complete(with: invalidJSON, statusCode: 200)

		XCTAssertEqual(capturedError, [.invalidData])
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
		var messages: [(url: URL, completion: (HTTPClientResult) -> Void)] = []
		var requestedURLs: [URL] {
			messages.map { $0.url }
		}

		func get(
			from url: URL,
			completion: @escaping (HTTPClientResult) -> Void
		) {
			messages.append((url, completion))
		}

		func complete(with error: Error, at index: Int = 0) {
			messages[index].completion(.failure(error))
		}

		func complete(
			with data: Data = Data(),
			statusCode: Int,
			at index: Int = 0
		) {
			let urlResponse = HTTPURLResponse(
				url: requestedURLs[index],
				statusCode: statusCode,
				httpVersion: nil,
				headerFields: nil
			)!
			messages[index].completion(.success(data, urlResponse))
		}
	}
}
