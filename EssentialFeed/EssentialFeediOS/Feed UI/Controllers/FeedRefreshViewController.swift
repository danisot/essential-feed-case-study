//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 15/7/23.
//

import UIKit

final class FeedRefreshViewController: NSObject {

    private let viewModel: FeedViewModel

    private(set) lazy var view = binded(UIRefreshControl())

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }

    @objc
    func refresh() {
        viewModel.loadFeed()
    }

    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            isLoading ? view?.beginRefreshing() : view?.endRefreshing()
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
