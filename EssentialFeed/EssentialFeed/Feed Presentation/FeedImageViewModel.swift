//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 1/8/23.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?

    public var hasLocation: Bool {
        location != nil
    }
}
