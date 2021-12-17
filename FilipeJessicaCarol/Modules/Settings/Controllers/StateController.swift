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
    
    func numberOfRowsInSection() -> Int {
        return states.count
    }
    
    func getStates() -> [State] {
        return states
    }
    
    func getStateByIndex(indexPath: IndexPath) -> State {
        return states[indexPath.row]
    }
    
    func getStateByRow(row: Int) -> State {
        return states[row]
    }
    
    func getStateByRow(row: Int) -> String {
        return states[row].name ?? ""
    }
    
    
    func loadingStates() {
        states = []
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "State")
        
        do {
            let result = try context.fetch(fetchReq) as? [State] ?? []
            var filterState = [State]()
            
            result.forEach { _state in
                if let _ = filterState.firstIndex(where: {$0.name == _state.name}) {
                    return
                } else {
                    filterState.append(_state)
                }
                
                states = filterState.sorted(by: { $0.name ?? "" < $1.name ?? ""})
            }
        }catch {
            print("error")
        }
    }
    
    func deleteStateById(id: NSManagedObjectID) {
      
        let object =  context.object(with: id)
        context.delete(object)
        
        do {
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
    
    
    func saveOnCoreData(states: States, completion: (Bool) -> Void) {
        let managedContext = context
        let state = State(context: managedContext)
        
        state.name = states.name
        state.taxes = states.taxes
        state.id = states.id
      
        do {
            try managedContext.save()
            self.loadingStates()
            completion(true)
        } catch let error as NSError {
            print("Houve um erro \(error)")
        }
    }
    
    
    
}
