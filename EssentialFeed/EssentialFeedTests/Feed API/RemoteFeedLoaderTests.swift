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

		expect(sut, toCompleteWith: failure(.connectivity), when: {
			let clientError = NSError(domain: "ClientError", code: 1)
			client.complete(with: clientError)
		})
	}

	func test_load_deliversErrorOnNon200HTTPResponseCode() {
		let (sut, client) = makeSUT()
		let invalidStatusCodes = [199, 201, 346, 404, 500]

		invalidStatusCodes.enumerated().forEach { index, code in
			expect(sut, toCompleteWith: failure(.invalidData), when: {
				let json = makeItemsJSON([])
				client.complete(with: json, statusCode: code, at: index)
			})
		}
	}

	func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
		let (sut, client) = makeSUT()

		expect(sut, toCompleteWith: failure(.invalidData), when: {
			let invalidJSON = Data("invalid JSON".utf8)
			client.complete(with: invalidJSON, statusCode: 200)
		})
	}

	func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
		let (sut, client) = makeSUT()
		let emptyValidData = makeItemsJSON([])

		expect(sut, toCompleteWith: .success([]), when: {
			client.complete(with: emptyValidData, statusCode: 200)
		})
	}

	func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
		let (sut, client) = makeSUT()

		let item1 = makeItem(
			id: UUID(),
			imageURL: URL(string: "http://a-url.com")!)

		let item2 = makeItem(
			id: UUID(),
			description: "a description",
			location: "a location",
			imageURL: URL(string: "http://another-url.com")!)

		let items = [item1.model, item2.model]

		expect(sut, toCompleteWith: .success(items), when: {
			let json = makeItemsJSON([item1.json, item2.json])
			client.complete(with: json, statusCode: 200)
		})
	}

	func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
		var sut: RemoteFeedLoader?
		let client = HTTPClientSpy()
		let url = URL(string: "https://any-url.com")!
		sut = RemoteFeedLoader(client: client, url: url)

		var capturedResults: [RemoteFeedLoader.Result] = []
		sut?.load { capturedResults.append($0) }

		sut = nil
		client.complete(with: makeItemsJSON([]), statusCode: 200)

		XCTAssertTrue(capturedResults.isEmpty)
	}

	// MARK: - Helpers

	private func makeSUT(
		url: URL = URL(string: "https://any-url.com")!,
		file: StaticString = #filePath,
		line: UInt = #line
	) -> (RemoteFeedLoader, HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteFeedLoader(client: client, url: url)
		trackForMemoryLeaks(client, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, client)
	}

	private func trackForMemoryLeaks(
		_ instance: AnyObject,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		addTeardownBlock { [weak instance] in
			XCTAssertNil(
				instance,
				"Instance should have been deallocated. Potential memory leak.",
				file: file,
				line: line
			)
		}
	}

	private func expect(
		_ sut: RemoteFeedLoader,
		toCompleteWith expectedResult: RemoteFeedLoader.Result,
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) {

		let exp = expectation(description: "Wait for load completion")

		sut.load { receivedResult in
			switch (receivedResult, expectedResult) {
			case let (.success(receivedItems), .success(expectedItems)):
				XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
			case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
				XCTAssertEqual(receivedError, expectedError, file: file, line: line)
			default:
				XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
			}
			exp.fulfill()
		}

		action()

		waitForExpectations(timeout: 1)
	}

	private func makeItem(
		id: UUID,
		description: String? = nil,
		location: String? = nil,
		imageURL: URL
	) -> (model: FeedItem, json: [String: Any]) {
		let item = FeedItem(
			id: id,
			description: description,
			location: location,
			imageURL: imageURL
		)
		let json = [
			"id": id.uuidString,
			"description": description,
			"location": location,
			"image": imageURL.absoluteString
		].compactMapValues { $0 }
		return (item, json)
	}

	private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
		let json = ["items": items]
		return try! JSONSerialization.data(withJSONObject: json)
	}

	private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
		.failure(error)
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
			with data: Data,
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