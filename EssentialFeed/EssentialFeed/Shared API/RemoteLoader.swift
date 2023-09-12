//
//  RemoteLoader.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 12/9/23.
//

import Foundation

public final class RemoteLoader<Resource> {

    public typealias Result = Swift.Result<Resource, Swift.Error>
    public typealias Mapper = (Data, HTTPURLResponse) throws -> Resource

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private let client: HTTPClient
    private let url: URL
    private let mapper: Mapper

    public init(client: HTTPClient, url: URL, mapper: @escaping Mapper) {
        self.client = client
        self.url = url
        self.mapper = mapper
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success((data, response)):
                completion(self.map(data, from: response))
            case .failure:
                completion(.failure(RemoteLoader.Error.connectivity))
            }
        }
    }

    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try mapper(data, response)
            return .success(items)
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
