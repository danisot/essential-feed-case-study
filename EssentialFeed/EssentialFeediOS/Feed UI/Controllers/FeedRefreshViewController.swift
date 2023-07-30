//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 15/7/23.
//

import UIKit

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}

final class FeedRefreshViewController: NSObject, FeedLoadingView {

    var delegate: FeedRefreshViewControllerDelegate?

    @IBOutlet private var view: UIRefreshControl?

    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }

    func display(_ viewModel: FeedLoadingViewModel) {
        viewModel.isLoading ? view?.beginRefreshing() : view?.endRefreshing()
    }
}

