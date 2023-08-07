//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by José Daniel Fernández Sotelo on 7/8/23.
//

import Foundation

extension HTTPURLResponse {

    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        statusCode == HTTPURLResponse.OK_200
    }
}
