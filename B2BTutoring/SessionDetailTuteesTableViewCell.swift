//
//  SessionDetailTuteesTableViewCell.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 11/22/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit

class SessionDetailTuteesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var enrollment: UILabel!
    @IBOutlet weak var showTutees: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
