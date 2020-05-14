//
//  GetUserResponse.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

struct GetUserResponse: Codable {
    let login: String
    let picUrl: String
    let publicFavoritesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case login
        case picUrl = "pic_url"
        case publicFavoritesCount = "public_favorites_count"
    }
}
