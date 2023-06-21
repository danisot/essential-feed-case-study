//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by José Daniel Fernández Sotelo on 21/6/23.
//

import XCTest

class LocalFeedLoader {
	init(store: FeedStore) {

	}
}

class FeedStore {
	var deleteCacheCallCount = 0
}

final class CacheFeedUseCaseTests: XCTestCase {
	
	func test_init_doesNotDeleteCacheUponCreation() {
		let store = FeedStore()
		_ = LocalFeedLoader(store: store)
		XCTAssertEqual(store.deleteCacheCallCount, 0)
	}
}
