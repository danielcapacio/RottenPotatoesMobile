//
//  PopularTableViewCell.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-16.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit

class PopularTableViewCell: UITableViewCell {

    @IBOutlet weak var label_popularTitle: UILabel!
    @IBOutlet weak var label_popularYear: UILabel!
    @IBOutlet weak var image_popularPoster: UIImageView!
    @IBOutlet weak var label_popularPopularity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
