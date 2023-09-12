//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 12/9/23.
//

import Foundation

public final class RemoteImageCommentsLoader: FeedLoader {

    public typealias Result = FeedLoader.Result

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private let client: HTTPClient
    private let url: URL

    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteImageCommentsLoader.map(data, from: response))
            case .failure:
                completion(.failure(RemoteImageCommentsLoader.Error.connectivity))
            }
        }
    }

    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try ImageCommentsMapper.map(data, response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteFeedItem {

    func toModels() -> [FeedImage] {
        map {
            FeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.image
            )
        }
    }
}
