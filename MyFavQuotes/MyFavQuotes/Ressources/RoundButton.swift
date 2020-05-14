//
//  RoundButton.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
    
    }
}
