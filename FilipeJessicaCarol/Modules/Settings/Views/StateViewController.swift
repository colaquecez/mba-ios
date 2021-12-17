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
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelIOF: UILabel!
    @IBOutlet weak var labelDolar: UILabel!
    @IBOutlet weak var iofInput: UITextField!
    @IBOutlet weak var dolarInput: UITextField!
    @IBOutlet weak var emptyText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        stateControler.loadingStates()
        tableView.register(UINib(nibName: "StateTableViewCell", bundle: nil), forCellReuseIdentifier: "StateTable")
        labelIOF.isHidden = true
        labelDolar.isHidden = true
        iofInput.keyboardType = .decimalPad
        dolarInput.keyboardType = .decimalPad
        emptyText.isHidden = true
        populateTextFields()
        viewContainer.frame.size.height = UIScreen.main.bounds.height / 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stateControler.loadingStates()
        tableView.reloadData()
    }
    
    func populateTextFields() {
        
        if stateControler.numberOfRowsInSection() == 0 {
            emptyText.isHidden = false
        }
        
        if let iofSettings = UserDefaults.standard.string(forKey: "preferences_iof") {
            iofInput.text = iofSettings
        }
        
        if let dolarSettings = UserDefaults.standard.string(forKey: "preferences_dolar")  {
            dolarInput.text = dolarSettings
        }
    }
    
    @IBAction func clickOnAddState(_ sender: Any) {
        showModalInputState(stateToChange: nil)
    }
    
    func showModalInputState(stateToChange:State?) {
        
        let alertController = UIAlertController(title: "Adicionar Estado", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Add", style: .default) { [self] (_) in
            alertController.textFields?.last?.keyboardType = .decimalPad
            
            if let stateName = alertController.textFields?.first, let textState = stateName.text {
                
                if let taxes = alertController.textFields?.last, let textTaxes = taxes.text {
                    
                    let newState = States(name: textState, taxes: Float(textTaxes) ?? 0, id: UUID().uuidString)
                    
                    if let stateToChange = stateToChange {
                        stateControler.changeStateById(id: stateToChange.id ?? "", state: newState)
                        
                        return  tableView.reloadData()
                    }
                    
                    stateControler.saveOnCoreData(states: newState) { resp in
                        emptyText.isHidden = true
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    }
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
        
        
        if let taxeSelected = stateToChange {
            alertController.textFields!.first!.text = taxeSelected.name
            alertController.textFields!.last!.text = String(taxeSelected.taxes)
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.textFields?.last?.keyboardType = .decimalPad
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let state = stateControler.getStateByIndex(indexPath: indexPath)
            
            stateControler.deleteStateById(id: state.objectID)
            
            if stateControler.numberOfRowsInSection() <= 0 {
                emptyText.isHidden = false
            }
            tableView.reloadData()
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateControler.numberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stateSelected = stateControler.getStateByIndex(indexPath: indexPath)
        showModalInputState(stateToChange: stateSelected)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StateTable", for: indexPath) as! StateTableViewCell
        
        let state = stateControler.getStateByIndex(indexPath: indexPath)
        
        cell.setupState(state: state)
        
        return cell
    }
    
}
