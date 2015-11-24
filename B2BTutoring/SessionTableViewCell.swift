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
        self.titleLabel.text = session.title
        self.categoryLabel.text = session.category
        self.tagLabel.text = session.tags
        self.tutorImageView.image = nil
        let sessionGeoPoint = session.locationGeoPoint
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint:PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                let userLocation = geoPoint
                self.locationLabel.text = NSString(format: "%.1fmi", (userLocation?.distanceInMilesTo(sessionGeoPoint))!) as String
            } else {
                print(error)
            }
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        self.timeLabel.text = dateFormatter.stringFromDate(session.starts)
        self.capacityLabel.text = String(session.tutees.count) + "/" + String(session.capacity)
        
        User.objectWithoutDataWithObjectId(session.tutor.objectId).fetchInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let user = object as? User {
                    user.profileThumbnail?.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if imageData != nil {
                            self.tutorImageView.image = UIImage(data: imageData!)
                        } else {
                            print(error)
                        }
                    })
                    self.ratingLabel.text = "★ " + String(user.rating)
                }
            } else {
                print("Error retrieving user sessions")
            }
        }
        
        // tutee labels
        let maxDisplayTuteeCount = 3
        let displayTuteeCount = min(session.tutees.count, maxDisplayTuteeCount)
        
        // TODO: remove placeholder
        
        // draw at most 3 labels
        for var i = 0; i < displayTuteeCount; i++ {
            let x = CGFloat(272 - 38 * i)
            let y = CGFloat(78)
            let size = CGFloat(30)
            let tuteeView = UIImageView.init(frame: CGRectMake(x, y, size, size))
            tuteeView.layer.cornerRadius = size / 2
            tuteeView.layer.masksToBounds = true
            User.objectWithoutDataWithObjectId(session.tutees[i].objectId).fetchInBackgroundWithBlock({
                (object: PFObject?, error: NSError?) -> Void in
                if let tutee = object as? User {
                    tutee.profileThumbnail?.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if imageData != nil {
                            tuteeView.image = UIImage(data: imageData!)
                            self.contentView.addSubview(tuteeView)
                        } else {
                            print(error)
                        }
                    })
                }
            })
        }
        
        // display ...
        if session.tutees.count > maxDisplayTuteeCount {
            let x = CGFloat(272 - 38 * 3 + 10)
            let y = CGFloat(88)
            let size = CGFloat(20)
            let dotLabel = UILabel.init(frame: CGRectMake(x, y, size, size))
            dotLabel.text = "..."
            self.contentView.addSubview(dotLabel)
        }
    }

}
