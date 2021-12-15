//
//  HomeController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 20/11/21.
//

import UIKit
import CoreData

class HomeController: NSObject {
    
    private var purchases: [Purchase] = []
    
    var purchaseIsEmpty: Bool {
        return purchases.isEmpty
    }
    
    func loadingPurchases() {
        let managedContext = context
        purchases = []
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        do {
            let result = try managedContext.fetch(fetchReq)
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as? String ?? ""
//                let state = data.value(forKey: "state") as? String ?? ""
                let value = data.value(forKey: "value") as? Float ?? 0
                let isCard = data.value(forKey: "isCard") as? Bool ?? false
                let sku = data.value(forKey: "sku") as? String ?? ""
                let image = data.value(forKey: "image") as? Data ?? Data()
                
                let newPurchases = Purchase(name: name, value: value, isCard: isCard, sku: sku, image: image)
                
                purchases.append(newPurchases)
            }
        }catch {
            print("error")
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return purchases.count
    }
    
    func getName(indexPath: IndexPath) -> String {
        return purchases[indexPath.row].name
    }
    
    func getProductByIndex(indexPath: IndexPath) -> Purchase {
        return purchases[indexPath.row]
    }
    
    func changePurchaseById(sku: String, purchase: Purchase) {
        let managedContext = context
        let newEntity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)!
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = newEntity
        let predicate = NSPredicate(format: "(sku = %@)", sku)
        request.predicate = predicate

        do {
            let results =
            try managedContext.fetch(request)
            let objectUpdate = results[0] as! NSManagedObject
            objectUpdate.setValue(purchase.name, forKey: "name")
            objectUpdate.setValue(purchase.value, forKey: "value")
            objectUpdate.setValue(purchase.state, forKey: "state")
            objectUpdate.setValue(purchase.image, forKey: "image")
            objectUpdate.setValue(purchase.isCard, forKey: "isCard")

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
    
    func deletePurchaseById(sku: String) {
        let managedContext = context
        let newEntity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)!
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = newEntity
        let predicate = NSPredicate(format: "(sku = %@)", sku)
        request.predicate = predicate
        
        do {
            let results =
            try managedContext.fetch(request)
            let objectToDelete = results[0] as! NSManagedObject
            
           managedContext.delete(objectToDelete)
           try managedContext.save()
           loadingPurchases()
                       
        } catch {
            print("error")
        }
    }
}
