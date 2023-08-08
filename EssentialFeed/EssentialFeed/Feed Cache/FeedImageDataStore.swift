//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 8/8/23.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
