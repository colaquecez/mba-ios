//
//  StateTableViewCell.swift
//  FilipeJessicaCarol
//
//  Created by Filipe Pereira Colaquecez on 09/12/21.
//

import UIKit

class StateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupState(state: State) {
        labelTitle.text =  state.name
        labelDescription.text = String(state.taxes)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
