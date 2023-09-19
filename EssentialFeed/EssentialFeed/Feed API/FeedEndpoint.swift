//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 19/9/23.
//

import Foundation

public enum FeedEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
