//
//  SessionTableViewCell.swift
//  B2BTutoring
//
//  Created by yingjun on 15/10/29.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

    @IBOutlet weak var tutorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(session: Session) -> Void {
        self.tutorImageView.image = UIImage(named:"starwar")
        self.titleLabel.text = session.title
        self.categoryLabel.text = session.category
        self.tagLabel.text = session.tags
        self.locationLabel.text = session.location
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.timeLabel.text = dateFormatter.stringFromDate(session.starts)
        self.capacityLabel.text = "2/10"
        self.ratingLabel.text = "☆4.7"
    }

}
