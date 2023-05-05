//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by José Daniel Fernández Sotelo on 5/5/23.
//

import XCTest

final class URLSessionHTTPClient {

	private let session: URLSession

	init(session: URLSession) {
		self.session = session
	}

	func get(from url: URL) {
		session.dataTask(with: url) { _, _, _ in

		}.resume()
	}
}

final class URLSessionHTTPClientTests: XCTestCase {

	func test_getFromURL_createsDataTaskWithURL() {
		let session = URLSessionSpy()
		let sut = URLSessionHTTPClient(session: session)
		let url = URL(string: "http://any-url.com")!

		sut.get(from: url)

		XCTAssertEqual(session.receivedURLs, [url])
	}

	func test_getFromURL_resumesDataTaskWithURL() {
		let session = URLSessionSpy()
		let sut = URLSessionHTTPClient(session: session)
		let url = URL(string: "http://any-url.com")!

		let task = URLSessionDataTaskSpy()
		session.stub(url: url, task: task)

		sut.get(from: url)

		XCTAssertEqual(task.resumeCallCount, 1)
	}
}

// MARK: - Helpers

private class URLSessionSpy: URLSession {

	var receivedURLs: [URL] = []
	var stubs: [URL: URLSessionDataTask] = [:]

	func stub(url: URL, task: URLSessionDataTask) {
		stubs[url] = task
	}

	override func dataTask(
		with url: URL,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
	) -> URLSessionDataTask {
		receivedURLs.append(url)
		return stubs[url] ?? FakeURLSessionDataTask()
	}
}

private class FakeURLSessionDataTask: URLSessionDataTask {
	override func resume() {}
}

private class URLSessionDataTaskSpy: URLSessionDataTask {

	var resumeCallCount = 0

	override func resume() {
		resumeCallCount += 1
	}
}
