//
//  StateController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 17/11/21.
//

import UIKit
import CoreData

class StateController: NSObject {

    private var states: [State] = []
    private var stateSelected: Set<State> = []
    
    func numberOfRowsInSection() -> Int {
        return states.count
    }
    
    func getStateByIndex(indexPath: IndexPath) -> State {
        return states[indexPath.row]
    }
    
    func getStateByRow(row: Int) -> String {
        return states[row].name ?? ""
    }
    
    func loadingStates() {
        states = []
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "State")
        
        do {
            let result = try context.fetch(fetchReq) as? [State] ?? []
            states = result
        }catch {
            print("error")
        }
    }
    
    func deleteStateById(id: String) {
        let newEntity = NSEntityDescription.entity(forEntityName: "State", in: context)!
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = newEntity
        let predicate = NSPredicate(format: "(id = %@)", id)
        request.predicate = predicate

        do {
            let results =
            try context.fetch(request)
            let objectToDelete = results[0] as! NSManagedObject

           context.delete(objectToDelete)
           try context.save()
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
    
    
    func saveOnCoreData(states: States) {
        let managedContext = context
        let state = State(context: managedContext)
        
        state.name = states.name
        state.taxes = states.taxes
        state.id = states.id
      
        do {
            try managedContext.save()
            self.loadingStates()
        } catch let error as NSError {
            print("Houve um erro \(error)")
        }
    }
    
    
    
}
