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
    
    func setupProduct(purchase: Purchase) {
        title.text = purchase.name
        price.text = String(purchase.value)
        showCase.image = UIImage(data: purchase.image)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
