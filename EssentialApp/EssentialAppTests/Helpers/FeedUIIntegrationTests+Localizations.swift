//
//  FeedUIIntegrationTests+Localizations.swift
//  EssentialFeediOSTests
//
//  Created by José Daniel Fernández Sotelo on 31/7/23.
//

import XCTest
import EssentialFeed

extension FeedUIIntegrationTests {

    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }

    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }

    var feedTitle: String {
        FeedPresenter.title
    }

    var commentsTitle: String {
        ImageCommentsPresenter.title
    }
}
