//
//  ViewController.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 11/11/21.
//
import UIKit
import PhotosUI

class DetailProductViewController: UIViewController {
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAvailable = true
        }
        imageView.isUserInteractionEnabled = true
        nameProductLabel.isHidden = true
        stateProductLabel.isHidden = true
        valueProductLabel.isHidden = true
        imageLabel.isHidden = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        checkSelectedProduct()
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
        
    }
    
    @IBAction func onClickRegister(_ sender: Any) {
        if validateFields() {
            
            if let selectedProduct = selectedProduct {
                
                selectedProduct.name = nameProduct.text!
                selectedProduct.value = Float(valueProduct.text!)!
                selectedProduct.state = stateProduct.text!
                selectedProduct.image = imageView.image!.jpegData(compressionQuality: 1.0)!
                
                homeController.changePurchaseById(sku: selectedProduct.sku, purchase: selectedProduct)
                navigationController?.popViewController(animated: true)
                return
            }
            
            let purchase = Purchase(name: nameProduct.text ?? "", state: stateProduct.text ?? "", value: Float(valueProduct.text ?? "0")!, isCard: true, sku: UUID().uuidString, image: imageView.image!.jpegData(compressionQuality: 1.0)!)
                homeController.saveOnCoreData(purchase: purchase)
                navigationController?.popViewController(animated: true)
            
        }
    }
    
    @IBAction func onPressPlusButton(_ sender: Any) {
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
