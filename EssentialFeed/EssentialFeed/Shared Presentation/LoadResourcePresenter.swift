//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 13/9/23.
//

import Foundation

public protocol ResourceView {
    func display(_ viewModel: String)
}

public final class LoadResourcePresenter {
    public typealias Mapper = (String) -> String

    private let resourceView: ResourceView
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    private let mapper: Mapper

    private var feedLoadError: String {
        NSLocalizedString(
            "FEED_VIEW_CONNECTION_ERROR",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(
        resourceView: ResourceView,
        errorView: FeedErrorView,
        loadingView: FeedLoadingView,
        mapper: @escaping Mapper
    ) {
        self.resourceView = resourceView
        self.errorView = errorView
        self.loadingView = loadingView
        self.mapper = mapper
    }

    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    public func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}