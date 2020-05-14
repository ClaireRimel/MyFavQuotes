//
//  ViewController.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController {
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTexField: UITextField!
    @IBOutlet var goButton: RoundButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let openSession = Session()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Color.lightPink, colorTwo: Color.pink, colorThree: Color.purple)
        
        loginTextField.delegate = self
        passwordTexField.delegate = self

        toggleActivityIndicator(shown: false)
    }
    
    @IBAction func tappedGoButton(_ sender: Any) {
           toggleActivityIndicator(shown: true)
    
        guard let userName = loginTextField.text, let password = passwordTexField.text else {
            return
        }
        
        openSession.request(userName: userName, password: password) { (result) in
            self.toggleActivityIndicator(shown: false)

            switch result {
            case let .success(response):
                self.performSegue(withIdentifier: "UserInfoSegue", sender: response)
            case let .failure(error):
                self.presentUIAlert(message: error.message)
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
         loginTextField.resignFirstResponder()
         passwordTexField.resignFirstResponder()
         
     }
     
     private func toggleActivityIndicator(shown: Bool) {
         activityIndicator.isHidden = !shown
         goButton.isEnabled = !shown
         goButton.setTitle(goButton.isEnabled ? "GO": "", for: .normal)
     }
}

extension SessionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
           return false
    }
}


