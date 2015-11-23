//
//  ProfileTableViewController.swift
//  B2BTutoring
//
//  Created by yingjun on 15/10/29.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import UIKit

class Entry {
    let key : String
    let value : String
    init(k : String, v : String) {
        self.key = k;
        self.value = v;
    }
}


class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImageButton: UIButton!
    @IBOutlet weak var profileSegmentedControl: UISegmentedControl!
    
    //let profile = Profile()
    var name:[String] = []
    var info:[Entry] = []
    var interest:[Entry] = []
    var tutorImage:UIImage!
    var backgroundImage:UIImage!
    var reviews:[Review] = [Review]()
    
    var tuteeSession = [Session]()
    var tutorSession = [Session]()
    /*
    @IBAction func cancelEditProfile(segue: UIStoryboardSegue) {
        print("cancel edit")
    }
    */
    
    @IBAction func completeEditProfile(segue: UIStoryboardSegue) {
        print("complete edit")
    }
    
    @IBAction func completePostReview(segue: UIStoryboardSegue) {
        print("complete PostReview")
        self.fetchData()
    }
    
    override func viewWillAppear(animated: Bool) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        
        self.tableView.tableHeaderView = self.headerView
        self.navigationItem.rightBarButtonItem?.enabled = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func fetchData() {
        if let currentUser = User.currentUser() {
            User.objectWithoutDataWithObjectId(currentUser.objectId).fetchInBackgroundWithBlock() {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    if let user = object as? User {
                        self.nameLabel.text = user.firstname + " " + user.lastname
                        self.name.removeAll()
                        self.name.append(user.firstname)
                        self.name.append(user.lastname)
                        
                        self.info.removeAll()
                        
                        if let email = user.email {
                            self.info.append(Entry(k: "Email:", v: email))
                        }
                        
                        if let phone = user.username {
                            self.info.append(Entry(k: "Phone", v: phone))
                        }
                        
                        if let intro = user.intro {
                            self.info.append(Entry(k: "Intro", v: intro))
                        }
                        
                        self.interest.removeAll()
                        
                        for (myKey, myVal) in user.interests {
                            self.interest.append(Entry(k: myKey, v: myVal))
                        }
                        
                        user.profileThumbnail?.getDataInBackgroundWithBlock({
                            (imageData: NSData?, error: NSError?) -> Void in
                            if imageData != nil {
                                self.tutorImage = UIImage(data: imageData!)
                                self.profileImageButton.setBackgroundImage(self.tutorImage, forState: .Normal)
                            } else {
                                print(error)
                            }
                        })
                        
                        user.backgroundThumbnail?.getDataInBackgroundWithBlock({
                            (imageData: NSData?, error: NSError?) -> Void in
                            if imageData != nil {
                                self.backgroundImage = UIImage(data: imageData!)
                                self.backgroundImageButton.setBackgroundImage(self.backgroundImage, forState: .Normal)
                            } else {
                                print(error)
                            }
                        })
                        
                        self.reviews = user.getReviews()
                        
                        self.tuteeSession = user.getPassedTuteeSessions()
                        self.tutorSession = user.getPassedTutorSessions()

                        self.tableView.reloadData()
                        
                    }
                } else {
                    print("Error loading user info")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch profileSegmentedControl.selectedSegmentIndex {
        case 1:
            self.headerView.frame = CGRectMake(0,0,0,0)
            self.headerView.hidden = true
            self.tableView.tableHeaderView = self.headerView
            self.navigationItem.rightBarButtonItem?.enabled = false
            break
        case 2:
            self.headerView.frame = CGRectMake(0,0,0,0)
            self.headerView.hidden = true
            self.tableView.tableHeaderView = self.headerView
            self.navigationItem.rightBarButtonItem?.enabled = false
            break
        default:
            self.headerView.frame = CGRectMake(0,0,600,260)
            self.headerView.hidden = false
            self.tableView.tableHeaderView = self.headerView
            self.navigationItem.rightBarButtonItem?.enabled = true
            break
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch profileSegmentedControl.selectedSegmentIndex {
        case 0:
            var count:Int = 1
            if (self.info.count > 2) {
                count++
            }
            if (self.interest.count > 0) {
                count++
            }
            return count
        case 2:
            return 2
        case 1:
            return 1
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch profileSegmentedControl.selectedSegmentIndex {
        case 0:
            switch section {
            case 0:
                return self.info.count-1
            case 1:
                if (self.interest.count > 0) {
                    return self.interest.count
                }
                else {
                    return 1
                }
            case 2:
                return 1
            default:
                return 0
            }
        case 2:
            if section == 0 {
                let count:Int = self.reviews.count
                if (count <= 3) {
                    return count
                }
                return 4
            }
            else {
                return self.tutorSession.count
            }
        case 1:
            return self.tuteeSession.count
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch profileSegmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoTableViewCell", forIndexPath: indexPath) as! InfoTableViewCell
            var entry: Entry
            switch indexPath.section{
            case 0:
                entry = self.info[indexPath.row]
                break
            case 1:
                if (self.interest.count > 0) {
                    entry = self.interest[indexPath.row]
                }
                else {
                    entry = self.info[info.count-1]
                }
                break
            default:
                entry = self.info[info.count-1]
                break
            }
            cell.keyLabel.text = entry.key
            cell.valueLabel.text = entry.value
            
            return cell
        case 2:
            if indexPath.section == 0 {
                if indexPath.row == 3 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("MoreTableViewCell", forIndexPath: indexPath)
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("ReviewTableViewCell", forIndexPath: indexPath) as! ReviewTableViewCell
                    
                    let rev:Review = self.reviews[indexPath.row]
                    
                    let tutee = rev.getTutee()
                    
                    tutee.profileThumbnail?.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if imageData != nil {
                            cell.tuteeImageView.image = UIImage(data: imageData!)
                        } else {
                            print(error)
                        }
                    })
                    
                    cell.ratingLabel.text = "★ " + String(rev.rating)
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                    cell.dateLabel.text = dateFormatter.stringFromDate(rev.date)
                    
                    cell.reviewTextLabel.text = rev.text

                    return cell
                }
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell", forIndexPath: indexPath) as! SessionTableViewCell
                cell.titleLabel.text = tutorSession[indexPath.row].title
                cell.categoryLabel.text = tutorSession[indexPath.row].category
                cell.tagLabel.text = tutorSession[indexPath.row].tags
                cell.tutorImageView.image = nil
                let sessionGeoPoint = tutorSession[indexPath.row].locationGeoPoint
                PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint:PFGeoPoint?, error: NSError?) -> Void in
                    if error == nil {
                        let userLocation = geoPoint
                        cell.locationLabel.text = NSString(format: "%.1fmi", (userLocation?.distanceInMilesTo(sessionGeoPoint))!) as String
                    } else {
                        print(error)
                    }
                }
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                cell.timeLabel.text = dateFormatter.stringFromDate(tutorSession[indexPath.row].starts)
                cell.capacityLabel.text = String(tutorSession[indexPath.row].tutees.count) + "/" + String(tutorSession[indexPath.row].capacity)
                
                User.objectWithoutDataWithObjectId(tutorSession[indexPath.row].tutor.objectId).fetchInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        if let user = object as? User {
                            user.profileThumbnail?.getDataInBackgroundWithBlock({
                                (imageData: NSData?, error: NSError?) -> Void in
                                if imageData != nil {
                                    cell.tutorImageView.image = UIImage(data: imageData!)
                                } else {
                                    print(error)
                                }
                            })
                            cell.ratingLabel.text = "★ " + String(user.rating)
                        }
                    } else {
                        print("Error retrieving user sessions")
                    }
                }
                
                // tutee labels
                let maxDisplayTuteeCount = 3
                let displayTuteeCount = min(tutorSession[indexPath.row].tutees.count, maxDisplayTuteeCount)
                
                // TODO: remove placeholder
                
                // draw at most 3 labels
                for var i = 0; i < displayTuteeCount; i++ {
                    let x = CGFloat(272 - 38 * i)
                    let y = CGFloat(78)
                    let size = CGFloat(30)
                    let tuteeView = UIImageView.init(frame: CGRectMake(x, y, size, size))
                    tuteeView.layer.cornerRadius = size / 2
                    tuteeView.layer.masksToBounds = true
                    User.objectWithoutDataWithObjectId(tutorSession[indexPath.row].tutees[i].objectId).fetchInBackgroundWithBlock({
                        (object: PFObject?, error: NSError?) -> Void in
                        if let tutee = object as? User {
                            tutee.profileThumbnail?.getDataInBackgroundWithBlock({
                                (imageData: NSData?, error: NSError?) -> Void in
                                if imageData != nil {
                                    tuteeView.image = UIImage(data: imageData!)
                                    cell.contentView.addSubview(tuteeView)
                                } else {
                                    print(error)
                                }
                            })
                        }
                    })
                }
                
                // display ...
                if tutorSession[indexPath.row].tutees.count > maxDisplayTuteeCount {
                    let x = CGFloat(272 - 38 * 3 + 10)
                    let y = CGFloat(88)
                    let size = CGFloat(20)
                    let dotLabel = UILabel.init(frame: CGRectMake(x, y, size, size))
                    dotLabel.text = "..."
                    cell.contentView.addSubview(dotLabel)
                }
                
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell", forIndexPath: indexPath) as! SessionTableViewCell
            cell.titleLabel.text = tuteeSession[indexPath.row].title
            cell.categoryLabel.text = tuteeSession[indexPath.row].category
            cell.tagLabel.text = tuteeSession[indexPath.row].tags
            cell.tutorImageView.image = nil
            let sessionGeoPoint = tuteeSession[indexPath.row].locationGeoPoint
            PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint:PFGeoPoint?, error: NSError?) -> Void in
                if error == nil {
                    let userLocation = geoPoint
                    cell.locationLabel.text = NSString(format: "%.1fmi", (userLocation?.distanceInMilesTo(sessionGeoPoint))!) as String
                } else {
                    print(error)
                }
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            cell.timeLabel.text = dateFormatter.stringFromDate(tuteeSession[indexPath.row].starts)
            cell.capacityLabel.text = String(tuteeSession[indexPath.row].tutees.count) + "/" + String(tuteeSession[indexPath.row].capacity)
            
            User.objectWithoutDataWithObjectId(tuteeSession[indexPath.row].tutor.objectId).fetchInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    if let user = object as? User {
                        user.profileThumbnail?.getDataInBackgroundWithBlock({
                            (imageData: NSData?, error: NSError?) -> Void in
                            if imageData != nil {
                                cell.tutorImageView.image = UIImage(data: imageData!)
                            } else {
                                print(error)
                            }
                        })
                        cell.ratingLabel.text = "★ " + String(user.rating)
                    }
                } else {
                    print("Error retrieving user sessions")
                }
            }
            
            // tutee labels
            let maxDisplayTuteeCount = 3
            let displayTuteeCount = min(tuteeSession[indexPath.row].tutees.count, maxDisplayTuteeCount)
            
            // TODO: remove placeholder
            
            // draw at most 3 labels
            for var i = 0; i < displayTuteeCount; i++ {
                let x = CGFloat(272 - 38 * i)
                let y = CGFloat(78)
                let size = CGFloat(30)
                let tuteeView = UIImageView.init(frame: CGRectMake(x, y, size, size))
                tuteeView.layer.cornerRadius = size / 2
                tuteeView.layer.masksToBounds = true
                User.objectWithoutDataWithObjectId(tuteeSession[indexPath.row].tutees[i].objectId).fetchInBackgroundWithBlock({
                    (object: PFObject?, error: NSError?) -> Void in
                    if let tutee = object as? User {
                        tutee.profileThumbnail?.getDataInBackgroundWithBlock({
                            (imageData: NSData?, error: NSError?) -> Void in
                            if imageData != nil {
                                tuteeView.image = UIImage(data: imageData!)
                                cell.contentView.addSubview(tuteeView)
                            } else {
                                print(error)
                            }
                        })
                    }
                })
            }
            
            // display ...
            if tuteeSession[indexPath.row].tutees.count > maxDisplayTuteeCount {
                let x = CGFloat(272 - 38 * 3 + 10)
                let y = CGFloat(88)
                let size = CGFloat(20)
                let dotLabel = UILabel.init(frame: CGRectMake(x, y, size, size))
                dotLabel.text = "..."
                cell.contentView.addSubview(dotLabel)
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoTableViewCell", forIndexPath: indexPath) as! InfoTableViewCell
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch profileSegmentedControl.selectedSegmentIndex {
        case 0:
            switch section{
            case 0:
                return "Basic"
            case 1:
                if (interest.count > 0) {
                    return "Interest"
                }
                else {
                    return "Review"
                }
            default:
                return "Review"
            }
        case 2:
            if section == 0 {
                return "Review"
            }
            else {
                return "History"
            }
        case 1:
            return "History"
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.font = UIFont(name: "Avenir-Heavy", size: 15)!
        header.textLabel!.textColor = UIColor.lightGrayColor()
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch profileSegmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoTableViewCell") as! InfoTableViewCell
            return cell.bounds.height
        case 2:
            if indexPath.section == 0 {
                if (indexPath.row == 3) {
                    let cell = tableView.dequeueReusableCellWithIdentifier("MoreTableViewCell")
                    return cell!.bounds.height
                }
                else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("ReviewTableViewCell") as! ReviewTableViewCell
                    return cell.bounds.height
                }
                
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
                return cell.bounds.height
            }
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
            return cell.bounds.height
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
            return cell.bounds.height
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editProfile" {
            let dstController = (segue.destinationViewController as! UINavigationController).viewControllers.first as! EditProfileViewController
            
            dstController.name = self.name
            dstController.info = self.info
            dstController.interest = self.interest
            dstController.tutorImage = self.tutorImage
            dstController.backgroundImage = self.backgroundImage
        }
        else if segue.identifier == "sessionInfo" {
            let dstController = segue.destinationViewController as! SessionInfoViewController;
            //dstController.xxx = xxx
        }
        else if segue.identifier == "reviewInfo" {
            let dstController = segue.destinationViewController as! ReviewTableViewController;
            dstController.reviews = self.reviews
        }
    }
    
}