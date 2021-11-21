//
//  StateController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 17/11/21.
//

import UIKit
import CoreData

class StateController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addNewState() {
        let state = States(name: "testando")
        let managedContext = context
        let newEntity = NSEntityDescription.entity(forEntityName: "State", in: managedContext)!
        let newProduct = NSManagedObject(entity: newEntity, insertInto: managedContext)
        newProduct.setValue(state.name, forKey: "name")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Houve um erro \(error)")
        }
        print("PASSOU")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCells", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "222"
        cell.contentConfiguration = content
        return cell
    }

}
