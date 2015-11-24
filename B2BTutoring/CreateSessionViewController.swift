//
//  CreateSessionViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 10/29/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit
import Eureka

class CreateSessionViewController: FormViewController, CLLocationManagerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum Category : String, CustomStringConvertible {
        case Art = "Art"
        case Cars_and_motorcycles = "Cars and motorcycles"
        case Cooking = "Cooking"
        case Design = "Design"
        case DIY_and_crafts = "DIY_and_crafts"
        case Film = "Film"
        case Health = "Health"
        case Music = "Music"
        case Photography = "Photography"
        case Sports = "Sports"
        
        var description : String { return rawValue }
        
        static let allValues = [Art, Cars_and_motorcycles, Cooking, Design, DIY_and_crafts, Film, Health, Music, Photography, Sports]
    }

    
    private func initializeForm() {
        let font = UIFont(name: "Avenir-Medium", size: 16.0)
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.textField.font = font
        }
        
        IntRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.textField.font = font
        }
        
        DateTimeInlineRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
    
        PickerInlineRow<Category>.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
        
        form =
            
            TextRow("Title").cellSetup {
                $0.cell.textField.placeholder = $0.row.tag
            }
            
            <<< LocationRow("Location") {
                $0.title = $0.tag
                PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint:PFGeoPoint?, error: NSError?) -> Void in
                    if error == nil {
                        let userLocation = CLLocation(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude)
                        self.form.setValues(["Location" : userLocation])
                    } else {
                        print(error)
                    }
                }
            }
        
//            <<< PickerRow<Category>("Category") { (row : PickerRow<Category>) -> Void in
//                row.options = Category.allValues
//                row.title = "Category"
//                row.value = row.options[0]
//            }
            
            <<< PickerInlineRow<Category>("Category") { (row : PickerInlineRow<Category>) -> Void in
                row.title = row.tag
                row.options = Category.allValues
                row.value = row.options[0]
            }
            
            <<< TextRow("Tags").cellSetup {
                $0.cell.textField.placeholder = $0.row.tag
            }
            
            <<< IntRow("Capacity").cellSetup {
                $0.cell.textField.placeholder = $0.row.tag
            }
            
            +++
            
            DateTimeInlineRow("Starts") {
                $0.title = $0.tag
                $0.value = NSDate()
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowByTag("Ends")
                    if row.value?.compare(endRow.value!) == .OrderedDescending {
                        endRow.value = NSDate(timeInterval: 60*60*24, sinceDate: row.value!)
                        endRow.cell!.backgroundColor = .whiteColor()
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        cell.datePicker.datePickerMode = .DateAndTime
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            
            <<< DateTimeInlineRow("Ends"){
                $0.title = $0.tag
                $0.value = NSDate()
                }
                .onChange { [weak self] row in
                    let startRow: DateTimeInlineRow! = self?.form.rowByTag("Starts")
                    if row.value?.compare(startRow.value!) == .OrderedAscending {
                        row.cell!.backgroundColor = .redColor()
                    }
                    else{
                        row.cell!.backgroundColor = .whiteColor()
                    }
                    row.updateCell()
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        cell.datePicker.datePickerMode = .DateAndTime
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
                }
        
            form +++=
                
            ImageRow("BackgroundImage"){
                $0.title = "Background Image"
            }
        
            form +++=
        
            TextAreaRow("Description") {
                $0.placeholder = "Description"
                $0.cell.textView.font = font
            }
    }
    
    func validate(fields: [String: Any?]) -> String? {
        if fields["Title"] as? String == nil {
            return "Title can't be empty!"
        }
        if fields["Location"] as? CLLocation == nil {
            return "Location can't be empty!"
        }
        if fields["Description"] as? String == nil {
            return "Description can't be empty!"
        }
        if let start_date = fields["Starts"] as? NSDate {
            if start_date.compare(NSDate()) == .OrderedAscending {
                return "Starts date must be in the future!"
            }
        } else {
            return "Starts date can't be empty!"
        }
        if let end_date = fields["Ends"] as? NSDate {
            if end_date.compare(NSDate()) == .OrderedAscending {
                return "Ends date must be in the future!"
            }
        } else {
            return "Ends date can't be empty!"
        }
        return nil
    }
    
    func alertHandler(alert: UIAlertAction!) -> Void {
        performSegueWithIdentifier("UnwindToSchedule", sender: self)
    }
    
    func createAlert(message: String, unwind: Bool) -> Void {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: unwind ? alertHandler : nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func createSession(sender: UIBarButtonItem) {
        let session = Session()
        let values = self.form.values()
        let errorMsg = validate(values)
        if errorMsg == nil {
            session.title = values["Title"] as! String
            
            let location = values["Location"] as! CLLocation
            session.locationGeoPoint = PFGeoPoint(location: location)
            // store session location
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                if error == nil && placemarks!.count > 0 {
                    let address = placemarks![0] as CLPlacemark
                    session.location = ""
                    if let subThoroughfare = address.subThoroughfare {
                        session.location = session.location + subThoroughfare + " "
                    }
                    if let thoroughfare = address.thoroughfare {
                        session.location = session.location + thoroughfare + ", "
                    }
                    if let locality = address.locality {
                        session.location = session.location + locality
                    }
                    if let postalCode = address.postalCode {
                        session.location = session.location + ", " + postalCode
                    }
                }
                
            })
            
            session.tags = values["Tags"] as? String
            session.descrip = values["Description"] as! String
            session.starts = values["Starts"] as! NSDate
            session.ends = values["Ends"] as! NSDate
            let c = values["Category"] as! Category
            session.category = c.description
            session.capacity = values["Capacity"] as! Int
            session.currentEnrollment = 0
            session.tutor = User.currentUser()!
            for _ in 1...4 {
                session.tutees.append(User.currentUser()!)
            }
            
            session.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    if let currentUser = User.currentUser() {
                        User.objectWithoutDataWithObjectId(currentUser.objectId).fetchInBackgroundWithBlock {
                            (object: PFObject?, error: NSError?) -> Void in
                            if error == nil {
                                if let user = object as? User {
                                    user.tutorSessions.append(session)
                                    user.saveInBackgroundWithBlock {
                                        (succeeded: Bool, error: NSError?) -> Void in
                                        if (succeeded) {
                                            self.createAlert("Successfully created session!", unwind: true)
                                        } else {
                                            print("Error updating user")
                                        }
                                    }
                                }
                            } else {
                                print("Error retrieving user sessions")
                            }
                        }
                    }
                } else {
                    self.createAlert("Unable to create session due to server error.", unwind: true)
                }
            }
            
            
        } else {
            createAlert(errorMsg!, unwind: false)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
