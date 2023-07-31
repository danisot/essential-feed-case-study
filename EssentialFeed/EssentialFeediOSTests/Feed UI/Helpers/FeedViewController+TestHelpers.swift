//
//  FeedViewController+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by José Daniel Fernández Sotelo on 15/7/23.
//

import UIKit
import EssentialFeediOS

extension FeedViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }

    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        feedImageView(at: index) as? FeedImageCell
    }

    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)

        let delegate = tableView.delegate
        let indexPath = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: indexPath)

        return view
    }

    func simulateFeedImageViewNearVisible(at row: Int) {
        let datasource = tableView.prefetchDataSource
        let indexPath = IndexPath(row: row, section: feedImagesSection)
        datasource?.tableView(tableView, prefetchRowsAt: [indexPath])
    }

    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewVisible(at: row)

        let datasource = tableView.prefetchDataSource
        let indexPath = IndexPath(row: row, section: feedImagesSection)
        datasource?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
    }

    var errorMessage: String? {
        errorView?.message
    }

    func isShowingLoadingIndicator() -> Bool {
        refreshControl?.isRefreshing == true
    }

    func numberOfRenderedFeedImageViews() -> Int {
        tableView.numberOfRows(inSection: feedImagesSection)
    }

    func feedImageView(at index: Int) -> UITableViewCell? {
        let datasource = tableView.dataSource
        let indexPath = IndexPath(row: index, section: feedImagesSection)
        let cell = datasource?.tableView(tableView, cellForRowAt: indexPath)

        return cell
    }

    private var feedImagesSection: Int { 0 }
}

