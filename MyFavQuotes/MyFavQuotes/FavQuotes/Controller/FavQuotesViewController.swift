//
//  FavQuotesViewController.swift
//  MyFavQuotes
//
//  Created by Claire on 14/05/2020.
//  Copyright © 2020 Claire Sivadier. All rights reserved.
//

import UIKit

class FavQuotesViewController: UITableViewController {
    
    var model: FavQuotesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.purple
        
        model?.request(then: { (result) in
            switch result {
            case .success:
                self.tableView.reloadData()
                break
            case let .failure(error):
                self.presentUIAlert(message: error.localizedDescription)
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.quotes.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavQuotesTablesViewCell", for: indexPath) as? FavQuotesTableViewCell else {
            return UITableViewCell()
        }
        
        if let quote = model?.quotes[indexPath.row] {
            cell.bodyLabel.text = #""\#(quote.body)""#
            cell.authorLabel.text = quote.author
            cell.idLabel.text = quote.id.description
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
