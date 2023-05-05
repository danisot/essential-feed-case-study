//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by José Daniel Fernández Sotelo on 5/5/23.
//

import XCTest
import EssentialFeed

protocol HTTPSession {
	func dataTask(
		with url: URL,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
	) -> HTTPSessionTask
}

protocol HTTPSessionTask {
	func resume()
}

final class URLSessionHTTPClient {

	private let session: HTTPSession

	init(session: HTTPSession) {
		self.session = session
	}

	func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
		session.dataTask(with: url) { _, _, error in
			if let error {
				completion(.failure(error))
			}
		}.resume()
	}
}

final class URLSessionHTTPClientTests: XCTestCase {

	func test_getFromURL_resumesDataTaskWithURL() {
		let session = HTTPSessionSpy()
		let sut = URLSessionHTTPClient(session: session)
		let url = URL(string: "http://any-url.com")!
		let task = URLSessionDataTaskSpy()
		session.stub(url: url, task: task)

		sut.get(from: url) { _ in }

		XCTAssertEqual(task.resumeCallCount, 1)
	}

	func test_getFromURL_failsOnRequestError() {
		let session = HTTPSessionSpy()
		let sut = URLSessionHTTPClient(session: session)
		let url = URL(string: "http://any-url.com")!
		let error = NSError(domain: "anyError", code: 1)
		session.stub(url: url, error: error)

		let exp = expectation(description: "Wait for completion")
		sut.get(from: url) { result in
			switch result {
			case let .failure(receivedError as NSError):
				XCTAssertEqual(receivedError, error)
			default:
				XCTFail("Expected failure with error \(error), got \(result) instead")
			}
			exp.fulfill()
		}

		waitForExpectations(timeout: 1)
	}
}

// MARK: - Helpers

private class HTTPSessionSpy: HTTPSession {

	private var stubs: [URL: Stub] = [:]

	private struct Stub {
		let task: HTTPSessionTask
		let error: Error?
	}

	func stub(url: URL, task: HTTPSessionTask = FakeURLSessionDataTask(), error: Error? = nil) {
		stubs[url] = Stub(task: task, error: error)
	}

	func dataTask(
		with url: URL,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
	) -> HTTPSessionTask {
		guard let stub = stubs[url] else {
			fatalError("Could not find stub for \(url)")
		}
		completionHandler(nil, nil, stub.error)
		return stub.task
	}
}

private class FakeURLSessionDataTask: HTTPSessionTask {
	func resume() {}
}

private class URLSessionDataTaskSpy: HTTPSessionTask {

	var resumeCallCount = 0

	func resume() {
		resumeCallCount += 1
	}
}
