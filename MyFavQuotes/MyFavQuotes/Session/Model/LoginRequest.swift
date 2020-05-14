//
//  LoginRequest.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let user: UserLoginRequest
}

struct UserLoginRequest: Codable {
    //username or email address
    let login: String
    
    //it is handled as plain-text
    let password: String
}
