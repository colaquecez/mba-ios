//
//  PurchaseController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 16/12/21.
//

import UIKit

class PurchaseController: NSObject {
    
    let productController = HomeController()
    let stateController = StateController()
    
    var iofValue: Float = 0
    var dolarValue: Float = 0
    
    
    
    
    func loadSettings() {
        if let iofSettings = UserDefaults.standard.string(forKey: "preferences_iof") {
            iofValue = Float(iofSettings) ?? 0
        }
        
        if let dolarSettings = UserDefaults.standard.string(forKey: "preferences_dolar")  {
            dolarValue = Float(dolarSettings) ?? 0
        }
    }
    
    func getAllUsdPurchases() -> Float {
        return Float(productController.getPurchases().reduce(into: 0) { partialResult, Product in
            partialResult += Product.value
        })
    }
    
    func getAllRealPurchases() -> Float {
        loadSettings()
        return productController.getPurchases().reduce(into: 0, { partialResult, Product in
            
            let product = Product.value + (Product.states?.taxes ?? 1 / 100 + 1)
            let iof = (product * (iofValue / 100 + 1)) * dolarValue
            let withoutIof = product * dolarValue
            
            if Product.isCard {
                return  partialResult += iof
            }
               return partialResult += withoutIof
           
        })
    }
}



