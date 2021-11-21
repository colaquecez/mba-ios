//
//  ViewController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 11/11/21.
//

import UIKit
import CoreData

class HomeViewController: UITableViewController {
    private let homeController = HomeController()
    
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
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.homeController.loadingPurchases()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            print("dekete")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyList.isHidden = !homeController.purchaseIsEmpty
        return homeController.numberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
        let product = homeController.getProductByIndex(indexPath: indexPath)
        cell.setupProduct(purchase: product)
          return cell
      }
    
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          guard let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailStoryboard") as? DetailProductViewController else {
              return
          }
          
          let product = homeController.getProductByIndex(indexPath: indexPath)
          vc.selectedProduct = product
          navigationController?.pushViewController(vc, animated: true)
      }

}



