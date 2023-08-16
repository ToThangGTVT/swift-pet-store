//
//  PetTableCell.swift
//  iOSTemplate
//
//  Created by ThangTQ on 11/08/2023.
//

import UIKit
import Kingfisher

class PetTableCell: UITableViewCell {
    
    @IBOutlet weak var imagePostView: UIImageView!
    @IBOutlet weak var title: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindView(post: ListPost) {
        title.text = post.title
        if let imageUrl = post.urlImageBanner {
            imagePostView.kf.setImage(with: URL(string: imageUrl))
        }
    }
}
