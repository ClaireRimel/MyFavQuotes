//
//  LoginResponse.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    //The "User-Token" should be added to the header for requests that require a user session.
    let userToken: String
    let login: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case userToken = "User-Token"
        case login
        case email
    }
}
