//
//  Session.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import Foundation

final class Session {
    
    func request(userName: String, password: String, then: @escaping (Result<LoginResponse, ErrorSession>) -> Void) {
        let url = URLConstructor.getURL(for: .session)
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(#"Token token="6267e30486bb12eabb4736851fdaa299""#, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        
        let userParameters = ["login": userName, "password": password]
        let parameters = ["user": userParameters]
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    then(.failure(.requestError(error)))
                }
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                //TODO: handle error
                return
            }
            
            if statusCode == 200 {
                guard let data = data,
                    let decodedResponse = try?
                        JSONDecoder().decode(LoginResponse.self, from: data) else {
                            DispatchQueue.main.async {
                                then(.failure(.invalidResponseFormat))
                            }
                            return
                }
                
                DispatchQueue.main.async {
                    then(.success(decodedResponse))
                    print(decodedResponse)
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
