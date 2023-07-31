//
//  WeakRefVirtualProxy.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 31/7/23.
//

import UIKit

final class WeakRefVirtualProxy<T: AnyObject> {

    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        object?.display(viewModel)
    }
}
