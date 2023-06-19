//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by José Daniel Fernández Sotelo on 5/5/23.
//

import XCTest
import EssentialFeed

final class URLSessionHTTPClient {

	struct UnexpectedValuesRepresentation: Error {}

	private let session: URLSession

	init(session: URLSession = .shared) {
		self.session = session
	}

	func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
		session.dataTask(with: url) { _, _, error in
			if let error {
				completion(.failure(error))
			} else {
				completion(.failure(UnexpectedValuesRepresentation()))
			}
		}.resume()
	}
}

final class URLSessionHTTPClientTests: XCTestCase {

	override func setUp() {
		super.setUp()
		URLProtocolStub.startInterceptingRequests()
	}

	override func tearDown() {
		super.tearDown()
		URLProtocolStub.stopInterceptingRequests()
	}

	func test_getFromURL_performsGETRequestWithURL() {
		let url = anyURL()

		let exp = expectation(description: "Wait for completion")
		URLProtocolStub.observerRequest { request in
			XCTAssertEqual(request.url, url)
			XCTAssertEqual(request.httpMethod, "GET")
			exp.fulfill()
		}

		makeSUT().get(from: url) { _ in }

		waitForExpectations(timeout: 1)
	}

	func test_getFromURL_failsOnRequestError() {
		let requestError = NSError(domain: "anyError", code: 1)
		let receivedError = resultErrorFor(data: nil, response: nil, error: requestError) as? NSError

		if let receivedError {
			XCTAssertEqual(receivedError.domain, requestError.domain)
			XCTAssertEqual(receivedError.code, requestError.code)
		} else {
			XCTFail("Expected \(requestError), got nil instead")
		}
	}

	func test_getFromURL_failsOnAllNilValues() {
		XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
	}

	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSessionHTTPClient {
		let sut = URLSessionHTTPClient()
		trackForMemoryLeaks(sut, file: file, line: line)
		return sut
	}

	private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> Error? {
		URLProtocolStub.stub(data: data, response: response, error: error)
		let sut = makeSUT(file: file, line: line)
		let exp = expectation(description: "Wait for completion")

		var receivedError: Error?
		sut.get(from: anyURL()) { result in
			switch result {
			case let .failure(error):
				receivedError = error
			default:
				XCTFail("Expected failure, got \(result) instead", file: file, line: line)
			}
			exp.fulfill()
		}

		waitForExpectations(timeout: 1)
		return receivedError
	}

	private func anyURL() -> URL {
		URL(string: "http://any-url.com")!
	}
}

// MARK: - Helpers

private class URLProtocolStub: URLProtocol {

	private static var requestObserver: ((URLRequest) -> Void)?
	private static var stub: Stub?

	private struct Stub {
		let data: Data?
		let response: URLResponse?
		let error: Error?
	}

	static func observerRequest(observer: @escaping (URLRequest) -> Void) {
		requestObserver = observer
	}

	static func stub(data: Data?, response: URLResponse?, error: Error?) {
		stub = Stub(data: data, response: response, error: error)
	}

	static func startInterceptingRequests() {
		URLProtocol.registerClass(URLProtocolStub.self)
	}

	static func stopInterceptingRequests() {
		URLProtocol.unregisterClass(URLProtocolStub.self)
		stub = nil
		requestObserver = nil
	}

	override class func canInit(with request: URLRequest) -> Bool {
		requestObserver?(request)
		return true
	}

	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		request
	}

	override func startLoading() {
		if let data = URLProtocolStub.stub?.data {
			client?.urlProtocol(self, didLoad: data)
		}

		if let response = URLProtocolStub.stub?.response {
			client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
		}

		if let error = URLProtocolStub.stub?.error {
			client?.urlProtocol(self, didFailWithError: error)
		}

		client?.urlProtocolDidFinishLoading(self)
	}

	override func stopLoading() {}
}
