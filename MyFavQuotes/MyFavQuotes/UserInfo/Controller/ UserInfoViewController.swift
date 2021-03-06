//
//  UserInfoViewController.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var nickname: UILabel!
    @IBOutlet var countOfFavQuotes: UILabel!
    @IBOutlet var seeFavorite: RoundButton!
    
    var model: UserInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Color.lightPink, colorTwo: Color.pink, colorThree: Color.purple)
        nickname.text = model?.userName
        model?.request(then: { (result) in
            switch result {
            case let .success(response):
                self.countOfFavQuotes.text = " \(response.publicFavoritesCount) ★"
                self.model?.getImage(url: response.picUrl, completion: { (result) in
                    switch result {
                    case let .success(image):
                        self.imageUser.image = image
                    case let .failure(error):
                        self.presentUIAlert(message: error.localizedDescription)
                    }
                })
                
            case let .failure(error):
                self.presentUIAlert(message: error.message)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavQuoteSegue" {
            if let destination = segue.destination as? FavQuotesViewController,
                let username = model?.userName,
                let userToken = model?.userToken {
                let model = FavQuotesModel(userName: username , userToken: userToken)
                destination.model = model
            }
        }
    }
}
