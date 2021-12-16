//
//  HomeController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 20/11/21.
//

import UIKit
import CoreData

class HomeController: NSObject {
    
    private var purchases: [Product] = []
    
    var purchaseIsEmpty: Bool {
        return purchases.isEmpty
    }
    
    func loadingPurchases() {
        let managedContext = context
        purchases = []
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        do {
            let result = try managedContext.fetch(fetchReq) as? [Product] ?? []
            
            purchases = result
        } catch {
            print("error")
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return purchases.count
    }
    
    func getName(indexPath: IndexPath) -> String {
        return purchases[indexPath.row].name ?? ""
    }
    
    func getProductByIndex(indexPath: IndexPath) -> Product {
        return purchases[indexPath.row]
    }
    
    func changePurchaseById(sku: NSManagedObjectID, purchase: Product) {
        let managedContext = context
        let newEntity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)!
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = newEntity
        let predicate = NSPredicate(format: "(sku = %@)", sku)
        request.predicate = predicate
        
        do {
            
            try managedContext.save()
            
        } catch {
            print("error")
        }
    }
    
    func saveOnCoreData(purchase: Purchase) {
        let managedContext = context
        let product = Product(context: managedContext)
        
        product.name = purchase.name
        product.value = purchase.value
        
        let states = State(context: managedContext)
        states.name = purchase.state
        product.states = states
        
        product.sku = purchase.sku
        product.image = purchase.image
        product.isCard = purchase.isCard
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Houve um erro \(error)")
        }
    }
    
    func deletePurchaseById(sku: NSManagedObjectID) {
        let managedContext = context
        let object = managedContext.object(with: sku)
        managedContext.delete(object)
        
        do {
            try managedContext.save()
            loadingPurchases()
            
        } catch {
            print("error")
        }
    }
}
