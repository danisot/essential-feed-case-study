//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by José Daniel Fernández Sotelo on 19/6/23.
//

import Foundation
import XCTest

extension XCTestCase {

	func trackForMemoryLeaks(
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
}
