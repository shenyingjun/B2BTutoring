//
//  SearchTableViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 10/28/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var sessions = [Session]()
    var filter : Filter?
    var currentSession: Session!

    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func search(sender: UIBarButtonItem) {
        Search.getPFQueryByString(Session.parseClassName(), searchString: searchBar.text)
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
    
    func doSearch(query: PFQuery, filter: Filter) {
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.sessions.removeAll()
                print("Successfully retrieved with filter")
                if let objects = objects as [PFObject]! {
                    for object in objects {
                        if let session = object as? Session {
                            if session.starts.compare(filter.starts) != NSComparisonResult.OrderedDescending
                                || session.ends.compare(filter.ends) != NSComparisonResult.OrderedAscending
                                || (filter.showOpen && session.tutees.count == session.capacity)
                                || session.expired() {
                                    continue
                            }
                            
                            if filter.lastname != nil || filter.firstname != nil || filter.rating != nil {
                                let tutor = session.tutor
                                do {
                                    try tutor.fetch()
                                    if (filter.lastname != nil && tutor.lastname != filter.lastname)
                                        || (filter.firstname != nil && tutor.firstname != filter.firstname)
                                        || (filter.rating != nil && tutor.rating < filter.rating) {
                                            continue
                                    }
                                } catch {
                                    print("error getting tutor info")
                                }
                            }
                            
                            self.sessions.append(session)
                        }
                    }
                    self.sortAndShowLoadedSessions()
                }
            }
        }
    }
    
    func doSearch(filter: Filter) {
        let baseQuery = Search.getPFQueryByString(Session.parseClassName(), searchString: searchBar.text)
        baseQuery.whereKey("category", equalTo: filter.category)
        if let distance = filter.distance {
            PFGeoPoint.geoPointForCurrentLocationInBackground { (currentGeoPoint:PFGeoPoint?, error: NSError?) -> Void in
                if currentGeoPoint != nil {
                    baseQuery.whereKey("locationGeoPoint", nearGeoPoint: currentGeoPoint!, withinMiles: distance)
                } else {
                    print("Failed to get current location")
                }
            }
        }
        self.doSearch(baseQuery, filter: filter)
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
    
    @IBAction func exitFilter(segue: UIStoryboardSegue) {
        if let myFilter = self.filter {
            doSearch(myFilter)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentSession = sessions[indexPath.row]
        performSegueWithIdentifier("Show Session Detail", sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionTableViewCell") as! SessionTableViewCell
        return cell.bounds.height
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Session Detail" {
            let dstController = segue.destinationViewController as! SessionDetailTableViewController;
            dstController.session = currentSession
            dstController.operation = currentSession.isFull() ? .Follow : .Join
        }
    }

}
