//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 18/2/23.
//

import Foundation

public struct FeedItem: Equatable {
	let id: UUID
	let description: String?
	let location: String?
	let imageURL: URL
}
