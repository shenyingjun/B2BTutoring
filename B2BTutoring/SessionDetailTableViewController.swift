//
//  SessionDetailTableViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 11/18/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit
import ChameleonFramework
import MapKit

enum SessionOperation {
    case Join
    case Follow
    case Quit
    case Unfollow
    case Cancel
    case None
}

class SessionDetailTableViewController: UITableViewController, MKMapViewDelegate {
    
    var session: Session!
    var operation: SessionOperation!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return operation == .None ? 3 : 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if section == 0 {
            numberOfRows = 2
        } else if section == 1 {
            numberOfRows = 3
        } else if section == 2 {
            numberOfRows = 2
        } else if section == 3 {
            numberOfRows = 1
        }
        return numberOfRows
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(150.0)
        }
        return CGFloat(10.0)
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let width = tableView.frame.size.width
            let height = CGFloat(150.0)
            let background = UIImageView(frame: CGRectMake(CGFloat(0.0), CGFloat(0.0), width, height))
            let image = UIImage.init(named: "telecaster.png")
            let resizedImage = Toucan(image: image!).resize(CGSize(width: width, height: height), fitMode: Toucan.Resize.FitMode.Crop).image
            background.image = resizedImage
            return background
        } else {
            return UIView(frame: CGRectZero)
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:  // title
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionTitleCell", forIndexPath: indexPath) as! SessionDetailTitleTableViewCell
                // move to init cell
                // controller shouldn't know about this
                cell.title.text = session.title
                cell.profile.setBackgroundImage(UIImage(), forState: .Normal)
                
                User.objectWithoutDataWithObjectId(session.tutor.objectId).fetchInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        if let user = object as? User {
                            user.profileThumbnail?.getDataInBackgroundWithBlock({
                                (imageData: NSData?, error: NSError?) -> Void in
                                if imageData != nil {
                                    cell.profile.setBackgroundImage(UIImage(data: imageData!), forState: .Normal)
                                } else {
                                    print(error)
                                }
                            })
                            let name = NSMutableAttributedString(string: user.firstname + " " + user.lastname + " ")
                            let rating = NSMutableAttributedString(string: "★\(user.rating)")
                            rating.addAttribute(NSForegroundColorAttributeName, value: UIColor.flatYellowColor(), range: NSRange(location: 0, length: rating.length))
                            rating.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir-Heavy", size: 14.0)!, range: NSRange(location: 0, length: rating.length))
                            name.appendAttributedString(rating)
                            cell.name.attributedText = name
                        }
                    } else {
                        print("Error retrieving user sessions")
                    }
                }
                
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionTuteesCell", forIndexPath: indexPath) as! SessionDetailTuteesTableViewCell
                cell.enrollment.text = "\(session.tutees.count) out of \(session.capacity)"
                return cell
            }
        case 1:  // basic info
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionBasicCell", forIndexPath: indexPath) as! SessionDetailBasicTableViewCell
                cell.icon.image = UIImage(named: "time")
                //cell.leftLabel.text = session.starts
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .MediumStyle
                dateFormatter.timeStyle = .ShortStyle
                let startDate = dateFormatter.stringFromDate(session.starts)
                let endDate = dateFormatter.stringFromDate(session.ends)
                cell.leftLabel.text = startDate + " - " + endDate
                cell.rightLabel.text = ""
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionBasicCell", forIndexPath: indexPath) as! SessionDetailBasicTableViewCell
                cell.icon.image = UIImage(named: "category")
                cell.leftLabel.text = session.category
                cell.rightLabel.text = session.tags
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionTextCell", forIndexPath: indexPath) as! SessionDetailTextTableViewCell
                cell.label.text = session.descrip
                return cell
            }
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionBasicCell", forIndexPath: indexPath) as! SessionDetailBasicTableViewCell
                cell.icon.image = UIImage(named: "location")
                cell.leftLabel.text = session.location
                cell.rightLabel.text = ""
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionMapCell", forIndexPath: indexPath) as! SessionDetailMapTableViewCell
                let location = CLLocation(latitude: session.locationGeoPoint.latitude, longitude: session.locationGeoPoint.longitude)
                let regionRadius: CLLocationDistance = 1000
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
                cell.map.setRegion(coordinateRegion, animated: true)
            
                let marker = MKPointAnnotation()
                marker.coordinate = location.coordinate
                cell.map.addAnnotation(marker)
                cell.map.delegate = self
                return cell
            }
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionButtonCell", forIndexPath: indexPath) as! SessionDetailButtonTableViewCell
                
                switch operation! {
                case .Join:
                    if session.isTutee(User.currentUser()!) {
                        cell.action.setTitle("Joined", forState: .Normal)
                        cell.action.userInteractionEnabled = false
                    } else {
                        cell.action.setTitle("Join", forState: .Normal)
                        cell.action.addTarget(self, action: "joinSession", forControlEvents: .TouchUpInside)
                    }
                case .Follow:
                    if session.isTutee(User.currentUser()!) {
                        cell.action.setTitle("Joined", forState: .Normal)
                        cell.action.userInteractionEnabled = false
                    } else if session.isFollower(User.currentUser()!) {
                        cell.action.setTitle("Followed", forState: .Normal)
                        cell.action.userInteractionEnabled = false
                    } else {
                        cell.action.setTitle("Follow", forState: .Normal)
                        cell.action.addTarget(self, action: "followSession", forControlEvents: .TouchUpInside)
                    }
                case .Quit:
                    cell.action.setTitle("Quit", forState: .Normal)
                    cell.action.addTarget(self, action: "quitSession", forControlEvents: .TouchUpInside)
                case .Unfollow:
                    cell.action.setTitle("Unfollow", forState: .Normal)
                    cell.action.addTarget(self, action: "quitSession", forControlEvents: .TouchUpInside)
                case .Cancel:
                    cell.action.setTitle("Cancel", forState: .Normal)
                    cell.action.addTarget(self, action: "cancelSession", forControlEvents: .TouchUpInside)
                case .None: break
                    
                }
                
                return cell
            }
        default: break
        }

        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = CGFloat(0.0)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                height = CGFloat(133.0)
            } else if indexPath.row == 1 {
                height = CGFloat(50.0)
            }
        case 1:
            if indexPath.row == 0 {
                height = CGFloat(50.0)
            } else if indexPath.row == 1 {
                height = CGFloat(50.0)
            } else if indexPath.row == 2 {
                
                let gettingSizeLabel = UILabel()
                gettingSizeLabel.font = UIFont(name: "Avenir", size: 14.0)
                gettingSizeLabel.text = session.descrip
                gettingSizeLabel.numberOfLines = 0;
                gettingSizeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                let maximumLabelSize = CGSizeMake(320.0, 20000.0)
                let expectSize = gettingSizeLabel.sizeThatFits(maximumLabelSize)
                
                return max(expectSize.height + 10.0, 100.0)
            }
        case 2:
            if indexPath.row == 0 {
                height = CGFloat(50.0)
            } else if indexPath.row == 1 {
                height = CGFloat(200.0)
            }
        case 3:
            if indexPath.row == 0 {
                height = CGFloat(40.0)
            }
        default: break
        }
        return height
    }
    
    func performSessionOp(op: User -> Void) {
        if let currentUser = User.currentUser() {
            User.objectWithoutDataWithObjectId(currentUser.objectId).fetchInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    if let user = object as? User {
                        op(user)
                    }
                } else {
                    self.createAlert("Oops! Something went wrong.", reload: false)
                }
            })
        }
    }
    
    func joinSession() {
        performSessionOp { (user: User) -> Void in
            user.joinSession(self.session)
            self.saveUserAndSession(user, session: self.session, successMessage: "Successfully joined session!")
        }
    }
    
    func followSession() {
        performSessionOp { (user: User) -> Void in
            user.followSession(self.session)
            self.saveUserAndSession(user, session: self.session, successMessage: "Succesfully followed session!")
        }
    }
    
    func quitSession() {
        performSessionOp { (user: User) -> Void in
            user.quitSession(self.session)
            self.saveUserAndSession(user, session: self.session, successMessage: "Successfully quit session!")
        }
    }
    
    func unfollowSession() {
        performSessionOp { (user: User) -> Void in
            user.unfollowSession(self.session)
            self.saveUserAndSession(user, session: self.session, successMessage: "Successfully unfollowed session!")
        }
    }
    
    func cancelSession() {
        if session.tutees.count == 0 {
            performSessionOp { (user: User) -> Void in
                user.cancelSession(self.session)
                
                user.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    let errorMessage = "Oops! Something went wrong."
                    if success {
                        self.session.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                            if success {
                                self.createAlert("Successfully canceled session", reload: false)
                            } else {
                                self.createAlert(errorMessage, reload: false)
                            }
                        })
                    } else {
                        self.createAlert(errorMessage, reload: false)
                    }
                }
                //self.saveUserAndSession(user, session: self.session, successMessage: "Successfully canceled session!")
            }
        } else {
            createAlert("Unable to cancel session with tutees!", reload: false)
        }
    }
    
    func alertHandler(alert: UIAlertAction!) -> Void {
        self.tableView.reloadData()
    }
    
    func createAlert(message: String, reload: Bool) -> Void {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: reload ? alertHandler : nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveUserAndSession(user: User, session: Session, successMessage: String) {
        user.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            let errorMessage = "Oops! Something went wrong."
            if success {
                session.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if success {
                        self.createAlert(successMessage, reload: true)
                    } else {
                        self.createAlert(errorMessage, reload: false)
                    }
                })
            } else {
                self.createAlert(errorMessage, reload: false)
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView()
        annotationView.image = UIImage(named: "marker")
        return annotationView
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "Show Tutees" {
            let dstController = segue.destinationViewController as! TuteesCollectionViewController
            dstController.tutees = session.tutees
        } else if segue.identifier == "Show Tutor Profile" {
            let dstController = segue.destinationViewController as! ProfileTableViewController
            dstController.user = session.tutor
        }
        
    }

}
