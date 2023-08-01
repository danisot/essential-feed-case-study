//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 31/7/23.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?

    static var noError: FeedErrorViewModel {
        FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        FeedErrorViewModel(message: message)
    }
}
