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
    
    // who's profile?
    var user: User!
    
    //let profile = Profile()
    var name:[String] = []
    var info:[Entry] = []
    var interest:[Entry] = []
    var tutorImage:UIImage!
    var backgroundImage:UIImage!
    var reviews:[Review] = [Review]()
    
    var tuteeSession = [Session]()
    var tutorSession = [Session]()
    
    var currentSession: Session!
    /*
    @IBAction func cancelEditProfile(segue: UIStoryboardSegue) {
        print("cancel edit")
    }
    */
    
    @IBAction func completeEditProfile(segue: UIStoryboardSegue) {
        print("complete edit")
        self.fetchData()
    }
    
    @IBAction func completePostReview(segue: UIStoryboardSegue) {
        print("complete PostReview")
        self.fetchData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.fetchData()
        
        self.tableView.tableHeaderView = self.headerView
        self.navigationItem.rightBarButtonItem?.enabled = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        user = nil
    }
    
    func fetchData() {
        if user == nil {
            user = User.currentUser()
        }
        
        if let currentUser = user {
            print(currentUser.objectId)
            PFUser.objectWithoutDataWithObjectId(currentUser.objectId).fetchInBackgroundWithBlock() {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    if let user = object as? User {
                        self.nameLabel.text = user.firstname + " " + user.lastname
                        self.name.removeAll()
                        self.name.append(user.firstname)
                        self.name.append(user.lastname)
                        
                        self.info.removeAll()
                        self.info.append(Entry(k: "Email:", v: user.email!))
                        self.info.append(Entry(k: "Phone", v: user.username!))
                        
                        if (user.intro != "") {
                            self.info.append(Entry(k: "Intro", v: user.intro))
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
                        
                        
                        let query = PFQuery(className: "Review").whereKey("tutorId", equalTo: user.objectId!)
                        query.findObjectsInBackgroundWithBlock { (reviews: [PFObject]?, error: NSError?) -> Void in
                            var myReviews = [Review]()
                            for r in reviews! {
                                let review = r as! Review
                                myReviews.append(review)
                                
                            }
                            self.reviews = myReviews
                            self.tuteeSession = user.getPassedTuteeSessions()
                            self.tutorSession = user.getPassedTutorSessions()
                            
                            self.tableView.reloadData()

                        }

                        
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
        self.fetchData()
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
                if (self.reviews.count == 0) {
                    return 1
                }
                if (self.reviews.count <= 3) {
                    return self.reviews.count
                }
                return 4
            }
            else {
                if (self.tutorSession.count == 0) {
                    return 1
                }
                return self.tutorSession.count
            }
        case 1:
            if (self.tuteeSession.count == 0) {
                return 1
            }
            return self.tuteeSession.count
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let font = UIFont(name: "Avenir-Medium", size: 16.0)
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
                    if (self.reviews.count == 0) {
                        let cell = UITableViewCell()
                        cell.textLabel?.font = font
                        cell.textLabel?.text = "No Reviews"
                        cell.textLabel?.textAlignment = NSTextAlignment.Center
                        cell.selectionStyle = UITableViewCellSelectionStyle.None
                        return cell
                    }
                    let cell = tableView.dequeueReusableCellWithIdentifier("ReviewTableViewCell", forIndexPath: indexPath) as! ReviewTableViewCell
                    cell.initCell(self.reviews[indexPath.row])
                    return cell
                }
            }
            else {
                if (self.tutorSession.count == 0) {
                    let cell = UITableViewCell()
                    cell.textLabel?.font = font
                    cell.textLabel?.text = "No History as a Tutor"
                    cell.textLabel?.textAlignment = NSTextAlignment.Center
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                }
                let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell", forIndexPath: indexPath) as! SessionTableViewCell
                cell.initCell(self.tutorSession[indexPath.row])
                return cell
            }
        case 1:
            if (self.tuteeSession.count == 0) {
                let cell = UITableViewCell()
                cell.textLabel?.font = font
                cell.textLabel?.text = "No History as a Tutee"
                cell.textLabel?.textAlignment = NSTextAlignment.Center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell", forIndexPath: indexPath) as! SessionTableViewCell
            cell.initCell(self.tuteeSession[indexPath.row])
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if profileSegmentedControl.selectedSegmentIndex == 1 {
            currentSession = tuteeSession[indexPath.row]
            performSegueWithIdentifier("Show Session Detail", sender: self)
        } else if profileSegmentedControl.selectedSegmentIndex == 2 && indexPath.section == 1 {
            currentSession = tutorSession[indexPath.row]
            performSegueWithIdentifier("Show Session Detail", sender: self)
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
        else if segue.identifier == "reviewInfo" {
            let dstController = segue.destinationViewController as! ReviewTableViewController;
            dstController.reviews = self.reviews
        }
        else if segue.identifier == "Show Session Detail" {
            let dstController = segue.destinationViewController as! SessionDetailTableViewController;
            dstController.session = currentSession
            dstController.operation = profileSegmentedControl.selectedSegmentIndex == 1 ? .Review : .None
        }
    }
    
}