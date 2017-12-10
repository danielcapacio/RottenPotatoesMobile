//
//  UpcomingTableViewCell.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-12-09.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_year: UILabel!
    @IBOutlet weak var label_releaseDate: UILabel!
    @IBOutlet weak var image_poster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
