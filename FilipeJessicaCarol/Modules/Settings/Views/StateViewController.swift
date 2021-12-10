//
//  StateController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 17/11/21.
//

import UIKit
import CoreData

class StateViewController: UITableViewController {
    @IBOutlet weak var addStateButton: UIButton!
    private let stateControler = StateController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "StateTableViewCell", bundle: nil), forCellReuseIdentifier: "StateTable")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stateControler.loadingStates()
        tableView.reloadData()
    }
    
    
    @IBAction func clickOnAddState(_ sender: Any) {
        showModalInputState()
    }
    
    func showModalInputState() {
        let alertController = UIAlertController(title: "Adicionar Estado", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { [self] (_) in
            if let stateName = alertController.textFields?.first, let textState = stateName.text {
                // operations
                
                if let taxes = alertController.textFields?[1], let textTaxes = taxes.text {
                    
                    let newState = States(name: textState, taxes: Float(textTaxes) ?? 0, id: UUID().uuidString)
                    stateControler.saveOnCoreData(state: newState)
                    tableView.reloadData()
                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (stateName) in
            stateName.placeholder = "Nome do estado"
        }
        alertController.addTextField { (taxes) in
            taxes.placeholder = "Imposto"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let state = stateControler.getStateByIndex(indexPath: indexPath)
            
            stateControler.deleteStateById(id: state.id)
            tableView.reloadData()
         
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateControler.numberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StateTable", for: indexPath) as! StateTableViewCell
        
        let state = stateControler.getStateByIndex(indexPath: indexPath)
        //
        cell.setupState(state: state)
        
        return cell
    }
    
}
