//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 31/7/23.
//

import Foundation

public final class FeedPresenter {

    public static var title: String {
        NSLocalizedString(
            "FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the feed view")
    }
}
