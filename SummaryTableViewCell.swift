//
//  SummaryTableViewCell.swift
//  Mapping
//
//  Created by Findlay Wood on 06/10/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    @IBOutlet var minuteLabel: UILabel!
    @IBOutlet var intensityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
