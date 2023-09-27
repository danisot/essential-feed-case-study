//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 15/7/23.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
