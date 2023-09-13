//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 31/7/23.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?

    static var noError: ResourceErrorViewModel {
        ResourceErrorViewModel(message: nil)
    }

    static func error(message: String) -> ResourceErrorViewModel {
        ResourceErrorViewModel(message: message)
    }
}
