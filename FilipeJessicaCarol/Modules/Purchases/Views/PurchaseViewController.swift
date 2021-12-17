//
//  PurchaseViewController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 16/12/21.
//

import UIKit

class PurchaseViewController: UIViewController {

    @IBOutlet weak var dolarTotalLabel: UILabel!
    @IBOutlet weak var realTotalLabel: UILabel!
    
    let purchaseController = PurchaseController()
    
    override func viewWillAppear(_ animated: Bool) {
        dolarTotalLabel.text = String(purchaseController.getAllUsdPurchases())
        realTotalLabel.text = String(purchaseController.getAllRealPurchases())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
