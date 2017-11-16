//
//  HomeTableViewCell.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-15.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var image_discoverImage: UIImageView!
    @IBOutlet weak var label_discoverTitle: UILabel!
    @IBOutlet weak var label_discoverSub: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(_ imageName: String, title: String, sub: String) {
        image_discoverImage.image = UIImage(named: imageName)
        label_discoverTitle.text = title
        label_discoverSub.text = sub
    }
    
}
