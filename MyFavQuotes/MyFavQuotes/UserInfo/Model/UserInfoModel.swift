//
//  UserInfoModel.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

final class UserInfoModel {
    
    let userName: String
    let userToken: String
    let imageDownloader = DownloadImage()
    
    init(userName: String, userToken: String ) {
        self.userName = userName
        self.userToken = userToken
    }
    
    func request(then: @escaping (Result<GetUserResponse, ErrorSession>) -> Void) {
        let url = URLConstructor.getURL(for: .users(userName: userName))
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(#"Token token="6267e30486bb12eabb4736851fdaa299""#, forHTTPHeaderField: "Authorization")
        urlRequest.addValue(userToken, forHTTPHeaderField: "User-Token")
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    then(.failure(.requestError(error)))
                }
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
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


