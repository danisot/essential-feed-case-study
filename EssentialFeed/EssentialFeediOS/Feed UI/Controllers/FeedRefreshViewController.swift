//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 15/7/23.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {

    private let presenter: FeedPresenter

    private(set) lazy var view = loadView()

    init(presenter: FeedPresenter) {
        self.presenter = presenter
    }

    @objc
    func refresh() {
        presenter.loadFeed()
    }

    func display(isLoading: Bool) {
        isLoading ? view.beginRefreshing() : view.endRefreshing()
    }

    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return view
    }
}

