//
//  ReviewTableViewCell.swift
//  B2BTutoring
//
//  Created by yingjun on 15/11/16.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var tuteeImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(review: Review) -> Void {
        let tutee = review.getTutee()
        
        tutee.profileThumbnail?.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if imageData != nil {
                self.tuteeImageView.image = UIImage(data: imageData!)
            } else {
                print(error)
            }
        })
        
        self.ratingLabel.text = "★ " + String(review.rating)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        self.dateLabel.text = dateFormatter.stringFromDate(review.date)
        
        self.reviewTextLabel.text = review.text
    }
}
