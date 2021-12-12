//
//  StateController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 17/11/21.
//

import UIKit
import CoreData

class StateController: NSObject {

    private var states: [States] = []
    
    
    func numberOfRowsInSection() -> Int {
        return states.count
    }
    
    func getStateByIndex(indexPath: IndexPath) -> States {
        return states[indexPath.row]
    }
    
    func getStateByRow(row: Int) -> String {
        return states[row].name
    }
    
    func loadingStates() {
        let managedContext = context
        states = []
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "State")
        
        do {
            let result = try managedContext.fetch(fetchReq)
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as? String ?? ""
                let taxes = data.value(forKey: "taxes") as? Float ?? 0
                let id = data.value(forKey: "id") as! String
                let newState = States(name: name, taxes: taxes, id: id)
                
                states.append(newState)
            }
        }catch {
            print("error")
        }
    }
    
    func deleteStateById(id: String) {
        let managedContext = context
       
        let newEntity = NSEntityDescription.entity(forEntityName: "State", in: managedContext)!
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = newEntity
        let predicate = NSPredicate(format: "(id = %@)", id)
        request.predicate = predicate

        do {
            let results =
            try managedContext.fetch(request)
            let objectToDelete = results[0] as! NSManagedObject

           managedContext.delete(objectToDelete)
           try managedContext.save()
           loadingStates()

        } catch {
            print("error")
        }
    }
    
    func changeStateById(id: String, state: States) {
        let managedContext = context
        let newEntity = NSEntityDescription.entity(forEntityName: "State", in: managedContext)!
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = newEntity
        let predicate = NSPredicate(format: "(id = %@)", id)
        request.predicate = predicate

        do {
            let results =
            try managedContext.fetch(request)
            let objectUpdate = results[0] as! NSManagedObject
            objectUpdate.setValue(state.name, forKey: "name")
            objectUpdate.setValue(state.taxes, forKey: "taxes")
            
            try managedContext.save()
            loadingStates()

        } catch {
            print("error")
        }
    }
    
    
    func saveOnCoreData(state: States) {
        let managedContext = context
        let newEntity = NSEntityDescription.entity(forEntityName: "State", in: managedContext)!
        let newState = NSManagedObject(entity: newEntity, insertInto: managedContext)
   
        newState.setValue(state.name, forKey: "name")
        newState.setValue(state.taxes, forKey: "taxes")
        newState.setValue(state.id, forKey: "id")
      
        do {
            try managedContext.save()
            self.loadingStates()
        } catch let error as NSError {
            print("Houve um erro \(error)")
        }
    }
    
    
    
}
