//
//  PetTableCell.swift
//  iOSTemplate
//
//  Created by ThangTQ on 11/08/2023.
//

import UIKit

class PetTableCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}