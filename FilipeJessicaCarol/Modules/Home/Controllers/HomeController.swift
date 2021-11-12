//
//  ViewController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 11/11/21.
//

import UIKit

class HomeController: UITableViewController {
    
    
    
   @objc func onClickButton(_sender: Any) {
       performSegue(withIdentifier: "ProductDetail", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Lista de Compras"
        
        
        configureItems()
    }
    
    
    
    private func configureItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onClickButton))
        
    }
}

