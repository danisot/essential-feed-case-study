//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 31/7/23.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {

    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher

    init(controller: ListViewController? = nil, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<FeedImageCellController>>(loader: { [imageLoader] in
                imageLoader(model.url)
            })

            let view = FeedImageCellController(
                viewModel: FeedImagePresenter.map(model),
                delegate: adapter)

            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(view),
                errorView: WeakRefVirtualProxy(view),
                loadingView: WeakRefVirtualProxy(view),
                mapper: { data in
                    guard let image = UIImage(data: data) else {
                        throw InvalidImageData()
                    }
                    return image
                })

            return CellController(view)
        })
    }
}

private struct InvalidImageData: Error {}
