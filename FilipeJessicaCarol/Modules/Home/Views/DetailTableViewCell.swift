//
//  DetailTableViewCell.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 20/11/21.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var showCase: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupProduct(purchase: Product) {
        title.text = purchase.name
        price.text = String(purchase.value)
        if let image = purchase.image {
            showCase.image = UIImage(data: image)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
