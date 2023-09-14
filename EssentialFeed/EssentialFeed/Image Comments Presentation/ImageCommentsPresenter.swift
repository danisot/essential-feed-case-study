//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 14/9/23.
//

import Foundation

public final class ImageCommentsPresenter {

    public static var title: String {
        NSLocalizedString(
            "IMAGE_COMMENTS_VIEW_TITLE",
            tableName: "ImageComments",
            bundle: Bundle(for: ImageCommentsPresenter.self),
            comment: "Title for the image comments view")
    }

    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}
