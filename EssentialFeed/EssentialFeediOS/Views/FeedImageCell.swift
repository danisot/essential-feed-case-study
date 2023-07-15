//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 13/7/23.
//

import UIKit

final public class FeedImageCell: UITableViewCell {
    public let locationContainer = UIView()
    public let locationLabel = UILabel()
    public let descriptionLabel = UILabel()
    public let feedImageContainer = UIView()
    public let feedImageView = UIImageView()

    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()

    var onRetry: (() -> Void)?

    @objc
    private func retryButtonTapped() {
        onRetry?()
    }
}
