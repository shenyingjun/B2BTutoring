//
//  EditProfileViewController.swift
//  B2BTutoring
//
//  Created by yingjun on 15/11/17.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import UIKit
import Eureka

class EditProfileViewController: FormViewController {

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
        
        NameRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.textField.font = font
        }
        
        EmailRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        PasswordRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
        
        PickerInlineRow<Category>.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        form =
            
            Section("Basic")
        
            <<< NameRow("First"){
                $0.title =  "First Name"
                $0.cell.textField.placeholder = "Leo"
            }
        
            <<< NameRow("Last"){
                $0.title =  "Last Name"
                $0.cell.textField.placeholder = "Luo"
            }

            <<< EmailRow("Email"){
                $0.title =  "Email"
                $0.cell.textField.placeholder = "leoluo@gmail.com"
            }
            
            <<< PasswordRow("Password"){
                $0.title =  "Password"
            }
        
            +++ Section("Image")
                
            <<< ImageRow("Profile"){
                $0.title = "Profile"
            }
            <<< ImageRow("Background"){
                $0.title = "Backgorund"
            }
            
            +++ Section("Interest 1")
            
            <<< TextRow("TagOne"){
                $0.title = "Tag"
                $0.cell.textField.placeholder = "one"
            }
            
            <<< PickerInlineRow<Category>("CategoryOne") { (row : PickerInlineRow<Category>) -> Void in
                row.title = "Category"
                row.options = Category.allValues
                row.value = row.options[0]
            }
            
            +++ Section("Interest 2")
            
            <<< TextRow("TagTwo"){
                $0.title = "Tag"
                $0.cell.textField.placeholder = "two"
            }
            
            <<< PickerInlineRow<Category>("CategoryTwo") { (row : PickerInlineRow<Category>) -> Void in
                row.title = "Category"
                row.options = Category.allValues
                row.value = row.options[0]
            }
            
            +++ Section("Interest 3")
            
            <<< TextRow("TagThree"){
                $0.title = "Tag"
                $0.cell.textField.placeholder = "three"
            }
            
            <<< PickerInlineRow<Category>("CategoryThree") { (row : PickerInlineRow<Category>) -> Void in
                row.title = "Category"
                row.options = Category.allValues
                row.value = row.options[0]
            }

            +++ Section("Intro")
            
            <<< TextAreaRow("Intro") {
                $0.placeholder = "I am Leo!!!!!!!"
                $0.cell.textView.font = font
            }
    }
    

    func validate(fields: [String: Any?]) -> String? {
        /*
        if fields["Title"] as? String == nil {
            return "Title can't be empty!"
        }
        if fields["Location"] as? String == nil {
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
        */
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
    
    @IBAction func editProfile(sender: UIBarButtonItem) {
        let session = Session()
        let values = self.form.values()
        let errorMsg = validate(values)
        if errorMsg == nil {
            /*
            user.title = values["Title"] as! String
            session.location = values["Location"] as! String
            session.tags = values["Tags"] as? String
            session.descrip = values["Description"] as! String
            session.starts = values["Starts"] as! NSDate
            session.ends = values["Ends"] as! NSDate
            let c = values["Category"] as! Category
            session.category =  c.description
            session.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    if let currentUser = User.currentUser() {
                        User.objectWithoutDataWithObjectId(currentUser.objectId).fetchInBackgroundWithBlock {
                            (object: PFObject?, error: NSError?) -> Void in
                            if error == nil {
                                if let user = object as? User {
                                    user.tutorSessions?.append(session)
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
            */
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
