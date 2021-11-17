//
//  ViewController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 11/11/21.
//

import UIKit

class HomeController: UITableViewController {
    let purchases: [String] = ["a","b"]
    
    @IBOutlet weak var emptyList: UILabel!
    
    private func configureItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onClickButton))
        
    }
    
    @objc func onClickButton(_sender: Any) {
       performSegue(withIdentifier: "ProductDetail", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Lista de Compras"
    
        configureItems()
        emptyList.isHidden = true
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(purchases.isEmpty) {
            emptyList.isHidden = false
        }
        
        return purchases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
          let cell = tableView.dequeueReusableCell(withIdentifier: "CellPurchases", for: indexPath)
          cell.textLabel?.text = purchases[indexPath.row]

          return cell
      }
    
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print(indexPath)
      }

}



