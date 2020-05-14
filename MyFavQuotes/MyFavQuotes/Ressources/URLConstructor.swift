//
//  URLConstructor.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

struct URLConstructor {
    
    enum Endpoint: Equatable {
        case quotes(userName: String)
        case users(userName: String)
        case session
    }
    
    static func getURL(for endpoint: Endpoint) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "favqs.com"
        
        switch endpoint {
        case .session:
            components.path = "/api/session"
            
        case let .users(userName):
            components.path = "/api/users/\(userName)"
            
        case let .quotes(userName):
            components.path = "/api/quotes"
            components.queryItems = [URLQueryItem(name: "filter", value: userName),
                                     URLQueryItem(name: "type", value: "user")]
        }
        
        return components.url!
    }
}
