//
//  QuoteResponse.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

struct QuoteResponse: Codable {
    let quotes: [Quote]
}

struct Quote: Codable {
    let id: Int
    let author: String
    let body: String
}
