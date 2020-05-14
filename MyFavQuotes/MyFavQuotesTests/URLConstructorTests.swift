//
//  URLConstructorTests.swift
//  MyFavQuotesTests
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import XCTest
@testable import MyFavQuotes

final class URLConstructorTests: XCTestCase {
    
    func testURLs() {
        let url = URLConstructor.getURL(for: .quotes(userName: "userName"))
        let url2 = URLConstructor.getURL(for: .users(userName: "userName"))
        let url3 = URLConstructor.getURL(for: .session)
        
        XCTAssertEqual(url.absoluteString, "https://favqs.com/api/quotes?filter=userName&type=user")
        XCTAssertEqual(url2.absoluteString, "https://favqs.com/api/users/userName")
        XCTAssertEqual(url3.absoluteString, "https://favqs.com/api/session")
    }
}
