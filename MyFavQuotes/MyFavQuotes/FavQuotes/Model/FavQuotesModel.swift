//
//  FavQuotesModel.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let quotesKey = "UserDefaults.quotesKey"
}

final class FavQuotesModel {
    let userName: String
    let userToken: String
    let cache = NSCache<NSString, NSString>()
    
    var quotes: [Quote] = []
    
    init(userName: String, userToken: String ) {
        self.userName = userName
        self.userToken = userToken
    }
    
    func request(then: @escaping (Result<Void, ErrorSession>) -> Void) {
        let url = URLConstructor.getURL(for: .quotes(userName: userName))
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(userToken, forHTTPHeaderField: "User-Token")
        urlRequest.addValue(#"Token token="6267e30486bb12eabb4736851fdaa299""#, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            if let error = error as NSError? {
                //No internet connection
                if error.domain == NSURLErrorDomain
                    && error.code == -1009 {
                    
                    //Verifies if there is any quote's data previously stored
                    if let data = UserDefaults.standard.data(forKey: UserDefaults.quotesKey),
                        let decodedData = try? JSONDecoder().decode(QuoteResponse.self, from: data) {
                        self.quotes = decodedData.quotes
                        DispatchQueue.main.async {
                            then(.success(()))
                        }
                    } else {
                        DispatchQueue.main.async {
                            then(.failure(.requestError(error)))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        then(.failure(.requestError(error)))
                    }
                }
                return
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                //ok
                guard let data = data,
                    let decodedResponse = try?
                        JSONDecoder().decode(QuoteResponse.self, from: data) else {
                            DispatchQueue.main.async {
                                then(.failure(.invalidResponseFormat))
                            }
                            return
                }
                self.quotes = decodedResponse.quotes
                print(decodedResponse)
                //Store quotes data for offline access
                UserDefaults.standard.set(data, forKey: UserDefaults.quotesKey)
                DispatchQueue.main.async {
                    then(.success(()))
                }
                
            } else {
                guard let data = data,
                    let decodedResponse = try?
                        JSONDecoder().decode(ErrorResponse.self, from: data) else {
                            DispatchQueue.main.async {
                                then(.failure(.invalidResponseFormat))
                            }
                            return
                }
                
                DispatchQueue.main.async {
                    let error = NSError(domain: "test", code: decodedResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: decodedResponse.message])
                    then(.failure(.requestError(error)))
                }
            }
        })
        task.resume()
    }
}
