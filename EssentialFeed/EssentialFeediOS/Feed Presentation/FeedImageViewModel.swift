//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by José Daniel Fernández Sotelo on 18/7/23.
//

import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        return location != nil
    }
}
