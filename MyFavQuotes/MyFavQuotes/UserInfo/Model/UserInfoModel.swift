//
//  UserInfoModel.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

class UserInfoModel {
    
    let userName: String
    let userToken: String
    let imageDownloader = DownloadImage()

    init(userName: String, userToken: String ) {
        self.userName = userName
        self.userToken = userToken
    }
    
    func request(then: @escaping (Result<GetUserResponse, ErrorSession>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "favqs.com"
        components.path = "/api/users/\(userName)"
        
        //Gets URL object based on given components
        let url = components.url!
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(#"Token token="6267e30486bb12eabb4736851fdaa299""#, forHTTPHeaderField: "Authorization")
        urlRequest.addValue(userToken, forHTTPHeaderField: "User-Token")
        urlRequest.httpMethod = "GET"
        
        //TODO: wrap code inside a Result type for better error handling
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
                //ok
                guard let data = data,
                    let decodedResponse = try?
                        JSONDecoder().decode(GetUserResponse.self, from: data) else {
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
    
    func getImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        imageDownloader.downloadImage(with: URL(string: url)!, completion: completion)
    }
}


