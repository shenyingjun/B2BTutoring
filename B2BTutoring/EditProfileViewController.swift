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
    var name:[String] = []
    var info:[Entry] = []
    var interest:[Entry] = []
    
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
        case DIY = "DIY"
        case Film = "Film"
        case Health = "Health"
        case Music = "Music"
        case Photography = "Photography"
        case Sports = "Sports"
        
        var description : String { return rawValue }
        
        static let allValues = [Art, Cars_and_motorcycles, Cooking, Design, DIY, Film, Health, Music, Photography, Sports]
        static let allStrings = ["Art", "Cars and motorcycles", "Cooking", "Design", "DIY", "Film", "Health", "Music", "Photography", "Sports"]
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
                $0.value = self.name[0]
            }
        
            <<< NameRow("Last"){
                $0.title =  "Last Name"
                $0.value = self.name[1]
            }

            <<< EmailRow("Email"){
                $0.title =  "Email"
                $0.value = self.info[0].value
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
                $0.value = ""
                if (self.interest.count >= 1) {
                    $0.value = self.interest[0].value
                }
            }
            
            <<< PickerInlineRow<Category>("CategoryOne") { (row : PickerInlineRow<Category>) -> Void in
                row.title = "Category"
                row.options = Category.allValues
                row.value = row.options[0]
                if (self.interest.count >= 1) {
                    row.value = row.options[Category.allStrings.indexOf(self.interest[0].key)!]
                }
            }
            
            +++ Section("Interest 2")
            
            <<< TextRow("TagTwo"){
                $0.title = "Tag"
                $0.value = ""
                if (self.interest.count >= 2) {
                    $0.value = self.interest[1].value
                }
            }
            
            <<< PickerInlineRow<Category>("CategoryTwo") { (row : PickerInlineRow<Category>) -> Void in
                row.title = "Category"
                row.options = Category.allValues
                row.value = row.options[0]
                if (self.interest.count >= 2) {
                    row.value = row.options[Category.allStrings.indexOf(self.interest[1].key)!]
                }
            }
            
            +++ Section("Interest 3")
            
            <<< TextRow("TagThree"){
                $0.title = "Tag"
                $0.value = ""
                if (self.interest.count >= 3) {
                    $0.value = self.interest[2].value
                }
            }
            
            <<< PickerInlineRow<Category>("CategoryThree") { (row : PickerInlineRow<Category>) -> Void in
                row.title = "Category"
                row.options = Category.allValues
                row.value = row.options[0]
                if (self.interest.count >= 3) {
                    row.value = row.options[Category.allStrings.indexOf(self.interest[2].key)!]
                }
            }

            +++ Section("Intro")
            
            <<< TextAreaRow("Intro") {
                $0.value = ""
                if (self.info.count >= 3) {
                    $0.value = self.info[2].value
                }
                $0.cell.textView.font = font
            }
    }
    

    func validate(fields: [String: Any?]) -> String? {
        if fields["First"] as? String == nil {
            return "First name can't be empty!"
        }
        if fields["Last"] as? String == nil {
            return "Last name can't be empty!"
        }
        if fields["Email"] as? String == nil {
            return "Email can't be empty!"
        }
        /*
        if fields["Password"] as? String == nil {
            return "Password can't be empty!"
        }
        */
        if fields["Intro"] as? String == nil {
            return "Intro can't be empty!"
        }
        /*
        if fields["Profile"] as? UIImage == nil {
            return "Profile can't be empty!"
        }
        if fields["Background"] as? UIImage == nil {
            return "Background can't be empty!"
        }
        */
        return nil
    }
    
    func alertHandler(alert: UIAlertAction!) -> Void {
        performSegueWithIdentifier("unwindToProfileTab", sender: self)
    }
    
    func createAlert(message: String, unwind: Bool) -> Void {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: unwind ? alertHandler : nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func editProfile(sender: UIBarButtonItem) {
        // let session = Session()
        let values = self.form.values()
        let errorMsg = validate(values)
        if errorMsg == nil {
            if let currentUser = User.currentUser() {
                User.objectWithoutDataWithObjectId(currentUser.objectId).fetchInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        if let user = object as? User {
                            // update user
                            user.firstname = values["First"] as! String
                            user.lastname = values["Last"] as! String
                            let password = values["Password"] as? String
                            if (password != "") {
                                user.password = password
                            }
                            user.email = values["Email"] as? String
                            user.intro = values["Intro"] as? String
                            
                            var new_interest = [String:String]()
                            var k: String
                            var v: String
                            if (values["TagOne"] as! String != "") {
                                k = (values["CategoryOne"] as! Category).description
                                v = values["TagOne"] as! String
                                new_interest[k] = v
                            }
                            if (values["TagTwo"] as! String != "") {
                                k = (values["CategoryTwo"] as! Category).description
                                v = values["TagTwo"] as! String
                                new_interest[k] = v
                            }
                            if (values["TagThree"] as! String != "") {
                                k = (values["CategoryThree"] as! Category).description
                                v = values["TagThree"] as! String
                                new_interest[k] = v
                            }
                            user.interests = new_interest
                            /*
                            let profile = UIImageJPEGRepresentation(values["Profile"] as! UIImage, 0.5)
                            user.profileImage = PFFile(name: "profile.jpg", data: profile!)!
                            let background = UIImageJPEGRepresentation(values["Background"] as! UIImage, 0.5)
                            user.backgroundImage = PFFile(name: "background.jpg", data: background!)!
                            */
                            user.saveInBackgroundWithBlock {
                                (succeeded: Bool, error: NSError?) -> Void in
                                if (succeeded) {
                                    self.createAlert("Successfully edited profile", unwind: true)
                                } else {
                                    print("Error updating user")
                                }
                            }
                        }
                    } else {
                        print("Error saving the edited profile")
                    }
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
