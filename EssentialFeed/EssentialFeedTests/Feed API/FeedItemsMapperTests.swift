//
//  FeedItemsMapperTests.swift
//  EssentialFeedTests
//
//  Created by José Daniel Fernández Sotelo on 18/2/23.
//

import XCTest
import EssentialFeed

final class FeedItemsMapperTests: XCTestCase {

	func test_map_throwsErrorOnNon200HTTPResponseCode() throws {
        let json = makeItemsJSON([])
		let invalidStatusCodes = [199, 201, 346, 404, 500]

        try invalidStatusCodes.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, HTTPURLResponse(statusCode: code))
            )
        }
	}

	func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid JSON".utf8)

        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSON, HTTPURLResponse(statusCode: 200))
        )
	}

	func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
		let emptyListJSON = makeItemsJSON([])

        let result = try FeedItemsMapper.map(emptyListJSON, HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
	}

	func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
		let item1 = makeItem(
			id: UUID(),
			imageURL: URL(string: "http://a-url.com")!)

		let item2 = makeItem(
			id: UUID(),
			description: "a description",
			location: "a location",
			imageURL: URL(string: "http://another-url.com")!)

        let json = makeItemsJSON([item1.json, item2.json])

        let result = try FeedItemsMapper.map(json, HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [item1.model, item2.model])
	}

	// MARK: - Helpers

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

	private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
		.failure(error)
	}
}
