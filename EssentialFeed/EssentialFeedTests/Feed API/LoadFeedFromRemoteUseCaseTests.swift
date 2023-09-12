//
//  LoadFeedFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by José Daniel Fernández Sotelo on 18/2/23.
//

import XCTest
import EssentialFeed

final class LoadFeedFromRemoteUseCaseTests: XCTestCase {

	func test_load_deliversErrorOnNon200HTTPResponseCode() {
		let (sut, client) = makeSUT()
		let invalidStatusCodes = [199, 201, 346, 404, 500]

		invalidStatusCodes.enumerated().forEach { index, code in
			expect(sut, toCompleteWith: failure(.invalidData), when: {
				let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
			})
		}
	}

	func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
		let (sut, client) = makeSUT()

		expect(sut, toCompleteWith: failure(.invalidData), when: {
			let invalidJSON = Data("invalid JSON".utf8)
			client.complete(withStatusCode: 200, data: invalidJSON)
		})
	}

	func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
		let (sut, client) = makeSUT()
		let emptyValidData = makeItemsJSON([])

		expect(sut, toCompleteWith: .success([]), when: {
            client.complete(withStatusCode: 200, data: emptyValidData)
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
			client.complete(withStatusCode: 200, data: json)
		})
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
	) -> (model: FeedImage, json: [String: Any]) {
		let item = FeedImage(
			id: id,
			description: description,
			location: location,
			url: imageURL
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
}
