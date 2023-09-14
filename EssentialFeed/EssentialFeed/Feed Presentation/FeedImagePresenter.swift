//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 1/8/23.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(description: image.description, location: image.location)
    }
}
