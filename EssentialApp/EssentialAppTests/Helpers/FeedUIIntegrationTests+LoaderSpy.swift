//
//  FeedUIIntegrationTests+LoaderSpy.swift
//  EssentialFeediOSTests
//
//  Created by José Daniel Fernández Sotelo on 15/7/23.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOS

extension FeedUIIntegrationTests {

    class LoaderSpy: FeedImageDataLoader {
        
        // MARK: - FeedLoader
        
        private var feedRequests: [PassthroughSubject<[FeedImage], Error>] = []
        
        var loadFeedCallCount: Int {
            feedRequests.count
        }
        
        func loadPublisher() -> AnyPublisher<[FeedImage], Error> {
            let publisher = PassthroughSubject<[FeedImage], Error>()
            feedRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            feedRequests[index].send(feed)
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let anyError = NSError(domain: "any error", code: 1)
            feedRequests[index].send(completion: .failure(anyError))
        }
        
        // MARK: - FeedImageDataLoader
        
        private struct TaskSpy: FeedImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }
        
        var loadedImageURLs: [URL] {
            imageRequests.map { $0.url }
        }
        
        private var imageRequests: [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)] = []
        
        private(set) var cancelledImageURLs: [URL] = []
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            let anyError = NSError(domain: "any error", code: 1)
            imageRequests[index].completion(.failure(anyError))
        }
    }
}
