//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 12/9/23.
//

import Foundation

final class ImageCommentsMapper {

    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }

    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }

        return root.items
    }
}
