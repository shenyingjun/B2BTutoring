//
//  SessionTableViewController.swift
//  B2BTutoring
//
//  Created by yingjun on 15/10/29.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import UIKit
import ChameleonFramework
import SWTableViewCell

class SessionTableViewController: UITableViewController, CLLocationManagerDelegate, SWTableViewCellDelegate {

    // user location
    var locationManager = CLLocationManager()

    // detail segue
    var currentSession: Session!
    var currentIndexPath: NSIndexPath!

    @IBOutlet weak var sessionSegmentedControl: UISegmentedControl!
    var sessions = [Session]()
    enum Source {
        case Tutor, Tutee, Follow
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.enabled = false
        loadData(Source.Tutee)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if currentIndexPath != nil {
            switch sessionSegmentedControl.selectedSegmentIndex {
            case 0:
                loadData(.Tutee)
            case 1:
                loadData(.Tutor)
            case 2:
                loadData(.Follow)
            default:
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch sessionSegmentedControl.selectedSegmentIndex {
        case 0:
            self.navigationItem.rightBarButtonItem?.enabled = false
            loadData(Source.Tutee)
            break
        case 1:
            self.navigationItem.rightBarButtonItem?.enabled = true
            loadData(Source.Tutor)
            break
        case 2:
            self.navigationItem.rightBarButtonItem?.enabled = false
            loadData(Source.Follow)
            break
        default:
            //TODO: avoid error
            break
        }
    }
    // MARK: - Table view data source

    func loadData(forTutor: Source) -> Void {
        if let currentUser = User.currentUser() {
            User.objectWithoutDataWithObjectId(currentUser.objectId).fetchInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    if let user = object as? User {
                        switch forTutor {
                        case .Tutor:
                            self.sessions = user.getOngoingTutorSessions()
                        case .Tutee:
                            self.sessions = user.getOngoingTuteeSessions()
                        case .Follow:
                            self.sessions = user.getOngoingFollowSessions()
                        }
                        self.tableView.reloadData()
                    }
                } else {
                    print("no current user")
                }
            })
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
        cell.initCell(self.sessions[indexPath.row])
        
        //cell.leftUtilityButtons
        let leftButtons: NSMutableArray = NSMutableArray()
        leftButtons.sw_addUtilityButtonWithColor(UIColor.flatGrayColor(), icon: UIImage(named: "message"))
        cell.leftUtilityButtons = leftButtons as [AnyObject]
        cell.delegate = self
        
        return cell
    }

    @IBAction func exitSessionCreation(segue: UIStoryboardSegue) {
        sessionSegmentedControl.selectedSegmentIndex = 1
        loadData(Source.Tutor)
        print("Exit session creation.")
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentSession = sessions[indexPath.row]
        currentIndexPath = indexPath
        performSegueWithIdentifier("Show Session Detail", sender: self)
    }

    // MARK: - Swipe
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        if index == 0 {
            print("SUCCESS!")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Session Detail" {
            let dstController = segue.destinationViewController as! SessionDetailTableViewController;
            dstController.session = currentSession
            if currentSession.isTutee(User.currentUser()!) {
                dstController.operation = .Quit
            } else if currentSession.isFollower(User.currentUser()!) {
                dstController.operation = .Unfollow
            } else {
                dstController.operation = .Cancel
            }
        }
    }

}
