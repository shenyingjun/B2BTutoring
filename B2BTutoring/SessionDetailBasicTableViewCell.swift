//
//  SessionDetailBasicTableViewCell.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 11/22/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit

class SessionDetailBasicTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
