//
//  ReviewsTableViewCell.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-24.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var label_date: UILabel!
    @IBOutlet weak var label_username: UILabel!
    @IBOutlet weak var label_movieTitle: UILabel!
    @IBOutlet weak var label_comment: UILabel!
    @IBOutlet weak var label_rating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
