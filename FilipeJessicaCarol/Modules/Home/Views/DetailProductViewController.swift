//
//  ViewController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 11/11/21.
//
import UIKit
import PhotosUI

class DetailProductViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameProduct: UITextField!
    @IBOutlet weak var stateProduct: UITextField!
    @IBOutlet weak var valueProduct: UITextField!
    @IBOutlet weak var switchCard: UISwitch!
    @IBOutlet weak var labelAddImage: UILabel!
    
    @IBOutlet weak var btRegister: UIButton!
    @IBOutlet weak var nameProductLabel: UILabel!
    @IBOutlet weak var stateProductLabel: UILabel!
    @IBOutlet weak var valueProductLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    
    var cameraAvailable: Bool = false
    var imageShowCase: String?
    var selectedProduct: Purchase?
    let homeController = HomeController()
    let stateController = StateController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAvailable = true
        }
        stateController.loadingStates()
        imageView.isUserInteractionEnabled = true
        nameProductLabel.isHidden = true
        pickerView.isHidden = true
        stateProductLabel.isHidden = true
        valueProductLabel.isHidden = true
        stateProduct.delegate = self
        nameProduct.delegate = self
        valueProduct.delegate = self
        imageLabel.isHidden = true
        switchCard.addTarget(self, action: #selector(didTapCard), for: UIControl.Event.valueChanged)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        checkSelectedProduct()
    }
    
    override func viewDidLayoutSubviews() {
        stateController.loadingStates()
        pickerView.reloadAllComponents()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == stateProduct {
            stateController.loadingStates()
            return pickerView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        return pickerView.isHidden = true
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == stateProduct {
            if stateController.numberOfRowsInSection() <= 0 {
              onPressPlusButton(self)
                pickerView.isHidden = true
                return false
            }
            pickerView.isHidden = !pickerView.isHidden
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func didTapCard(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        switchCard.isOn = value
    }
    
    func checkSelectedProduct() {
        guard let selectedProduct = selectedProduct else {
            return
        }
        
        btRegister.setTitle("Editar", for: .normal)
        nameProduct.text = selectedProduct.name
        stateProduct.text = selectedProduct.state
        valueProduct.text = String(selectedProduct.value)
        imageView.image = UIImage(data: selectedProduct.image)
        labelAddImage.isHidden = true
        switchCard.isOn = selectedProduct.isCard
        
    }
    
    
    
    @IBAction func onClickRegister(_ sender: Any) {
        if validateFields() {
            
            if let selectedProduct = selectedProduct {
                
                selectedProduct.name = nameProduct.text!
                selectedProduct.value = Float(valueProduct.text!)!
                selectedProduct.state = stateProduct.text!
                selectedProduct.image = imageView.image!.jpegData(compressionQuality: 1.0)!
                selectedProduct.isCard = switchCard.isOn
                
                homeController.changePurchaseById(sku: selectedProduct.sku, purchase: selectedProduct)
                navigationController?.popViewController(animated: true)
                return
            }
            
            let purchase = Purchase(name: nameProduct.text ?? "", state: stateProduct.text ?? "", value: Float(valueProduct.text ?? "0")!, isCard: switchCard.isOn, sku: UUID().uuidString, image: imageView.image!.jpegData(compressionQuality: 1.0)!)
            homeController.saveOnCoreData(purchase: purchase)
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    @IBAction func onPressPlusButton(_ sender: Any) {
        pickerView.isHidden = true
        performSegue(withIdentifier: "SettingScreen", sender: self)
    }
    
    func validateFields() -> Bool {
        guard let nameIsEmpty = nameProduct.text?.isEmpty else {
            return false
        }
        
        guard let stateIsEmpty = stateProduct.text?.isEmpty else {
            return false
        }
        
        guard let valueIsEmpty = valueProduct.text?.isEmpty else {
            return false
        }
        
        if nameIsEmpty {
            nameProductLabel.isHidden = false
        } else { nameProductLabel.isHidden = true }
        
        if stateIsEmpty {
            stateProductLabel.isHidden = false
        } else { stateProductLabel.isHidden = true }
        
        if valueIsEmpty {
            valueProductLabel.isHidden = false
        } else { valueProductLabel.isHidden = true }
        
        if imageView.image?.size.width != nil {
            imageLabel.isHidden = true
        } else {
            imageLabel.isHidden = false
            return false
            
        }
        
        if !nameIsEmpty && !stateIsEmpty && !valueIsEmpty {
            
            return true
        }
        
        return false
    }
    
    
    private func showPicker(alertARgument: UIAlertAction!) {
        var config:PHPickerConfiguration = PHPickerConfiguration()
        config.filter = PHPickerFilter.images
        config.selectionLimit = 1
        
        let picker: PHPickerViewController = PHPickerViewController(configuration: config)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    private func showCamera(alertArgument:UIAlertAction!) {
        let ac = UIImagePickerController()
        ac.allowsEditing = true
        ac.delegate = self
        ac.sourceType = .camera
        present(ac, animated: true, completion: nil)
    }
    
    
    @objc private func imageViewTapped(sourceType: UIImagePickerController.SourceType) {
        
        let ac = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: self.showPicker))
        
        if(cameraAvailable) {
            ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: self.showCamera))
        }
        
        ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
}

extension DetailProductViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard !results.isEmpty else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        for item in results {
            item.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.labelAddImage.isHidden = true
                        self.imageView.image = image
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension DetailProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension DetailProductViewController: UIPickerViewDataSource,UIPickerViewDelegate
{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateController.numberOfRowsInSection()
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateController.getStateByRow(row: row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateProduct.text = stateController.getStateByRow(row: row)
        return pickerView.isHidden = true
    }
    
}
