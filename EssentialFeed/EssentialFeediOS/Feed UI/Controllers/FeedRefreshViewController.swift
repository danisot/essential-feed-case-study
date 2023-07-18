//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 15/7/23.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {

    private let loadFeed: () -> Void

    private(set) lazy var view = loadView()

    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }

    @objc
    func refresh() {
        loadFeed()
    }

    func display(_ viewModel: FeedLoadingViewModel) {
        viewModel.isLoading ? view.beginRefreshing() : view.endRefreshing()
    }

    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return view
    }
}

