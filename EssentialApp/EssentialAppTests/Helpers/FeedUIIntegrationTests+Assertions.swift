//
//  FeedUIIntegrationTests+Assertions.swift
//  EssentialFeediOSTests
//
//  Created by José Daniel Fernández Sotelo on 15/7/23.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

extension FeedUIIntegrationTests {
    
    func assertThat(_ sut: ListViewController, isRendering feed: [FeedImage], file: StaticString = #filePath, line: UInt = #line) {
        sut.view.enforceLayoutCycle()

        guard sut.numberOfRenderedFeedImageViews() == feed.count else {
            return XCTFail("Expected \(feed.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead", file: file, line: line)
        }
        
        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }

        executeRunLoopToCleanUpReferences()
    }
    
    func assertThat(_ sut: ListViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.feedImageView(at: index)
        
        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        let shouldLocationBeVisible = image.location != nil
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expect isShowingLocation to be \(shouldLocationBeVisible), for image view at index \(index)", file: file, line: line)
        
        XCTAssertEqual(cell.locationText, image.location, "Expect location text to be \(String(describing: image.location)), for image view at index \(index)", file: file, line: line)
        
        XCTAssertEqual(cell.descriptionText, image.description, "Expect description text to be \(String(describing: image.description)), for image view at index \(index)", file: file, line: line)
    }

    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}
