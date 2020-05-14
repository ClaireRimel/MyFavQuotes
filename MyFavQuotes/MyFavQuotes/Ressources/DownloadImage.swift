//
//  DownloadImage.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

final class DownloadImage {
    
    var task: URLSessionDataTask?
    
    func downloadImage(with url: URL, cancellable: Bool = false, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    completion(.failure(error))
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    completion(.success(image))
                }
            }
        
        }
        task.resume()
    }
}
