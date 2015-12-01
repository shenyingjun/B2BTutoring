//
//  ExploreTableViewController.swift
//  B2BTutoring
//
//  Created by Reggie Huang on 11/18/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit

class ExploreTableViewController: UITableViewController {
    
    @IBOutlet weak var exploreSegment: UISegmentedControl!
    
    var sessions = [Session]()
    var currentSession: Session!
    var currentIndexPath: NSIndexPath!
    
    @IBAction func doRefresh(sender: UIRefreshControl) {
        switch exploreSegment.selectedSegmentIndex {
        case 0:
            loadDataForInterest()
            break
        case 1:
            loadDataForPopular()
            break
        default:
            //TODO: avoid error
            break
        }
        sender.endRefreshing()
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch exploreSegment.selectedSegmentIndex {
        case 0:
            loadDataForInterest()
            break
        case 1:
            loadDataForPopular()
            break
        default:
            //TODO: avoid error
            break
        }
    }
    
    func sortAndShowLoadedSessions() {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint:PFGeoPoint?, error: NSError?) -> Void in
            self.sessions.sortInPlace({ $0.getSortingScore(geoPoint) > $1.getSortingScore(geoPoint)})
            self.tableView.reloadData()
            if error != nil {
                print(error)
            }
        }
    }
    
    func loadDataForInterest() {
        if let currentUser = User.currentUser() {
            User.objectWithoutDataWithObjectId(currentUser.objectId).fetchInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    if let user = object as? User {
                        Search.getInterestPFQuery(Session.parseClassName(), interests: user.interests)
                            .findObjectsInBackgroundWithBlock {
                                (objects: [PFObject]?, error: NSError?) -> Void in
                                if error == nil {
                                    self.sessions.removeAll()
                                    print("Successfully retrieved")
                                    if let objects = objects as [PFObject]! {
                                        for object in objects {
                                            if let session = object as? Session {
                                                if !session.expired() {
                                                    self.sessions.append(session)
                                                }
                                            }
                                        }
                                        self.sortAndShowLoadedSessions()
                                    }
                                }
                        }
                    }
                } else {
                    print("Error retrieving user interested sessions")
                }
            }
        } else {
            print("no current user")
        }
    }
    
    func loadDataForPopular() {
        let query = PFQuery(className: Session.parseClassName())
        if let currentUser = User.currentUser() {
            query.whereKey("tutor", notEqualTo: currentUser)
        }
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.sessions.removeAll()
                print("Successfully retrieved")
                if let objects = objects as [PFObject]! {
                    for object in objects {
                        if let session = object as? Session {
                            if !session.expired() {
                                self.sessions.append(session)
                            }
                        }
                    }
                    self.sortAndShowLoadedSessions()
                }
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataForInterest()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if currentIndexPath != nil {
            self.tableView.reloadRowsAtIndexPaths([currentIndexPath], withRowAnimation: .None)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sessions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell", forIndexPath: indexPath) as! SessionTableViewCell
        cell.initCell(self.sessions[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentSession = sessions[indexPath.row]
        currentIndexPath = indexPath
        performSegueWithIdentifier("Show Session Detail", sender: self)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
        return cell.bounds.height
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Session Detail" {
            let dstController = segue.destinationViewController as! SessionDetailTableViewController;
            dstController.session = currentSession
            dstController.operation = currentSession.isFull() ? .Follow : .Join
        }
    }
    
}
