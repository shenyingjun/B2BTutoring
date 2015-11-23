//
//  PostReviewViewController.swift
//  B2BTutoring
//
//  Created by yingjun on 15/11/17.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import UIKit
import Eureka

class PostReviewViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initializeForm() {
        let font = UIFont(name: "Avenir-Medium", size: 16.0)
        
        IntRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        form +++=
            PickerInlineRow<Int>("Rating") { (row : PickerInlineRow<Int>) -> Void in
                row.title = "Rating"
                for i in 1...5{
                    row.options.append(i)
                }
                row.value = row.options[0]
            }

        form +++=
            TextAreaRow("Review") {
                $0.placeholder = "Review"
            }
        
    }
    
    
    func validate(fields: [String: Any?]) -> String? {
        if fields["Review"] as? String == nil {
            return "Review can't be empty!"
        }
        return nil
    }
    
    func alertHandler(alert: UIAlertAction!) -> Void {
        performSegueWithIdentifier("unwindToSessionInfo", sender: self)
    }
    
    func createAlert(message: String, unwind: Bool) -> Void {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: unwind ? alertHandler : nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func postReview(sender: UIBarButtonItem) {
        let review = Review()
        let values = self.form.values()
        let errorMsg = validate(values)
        if errorMsg == nil {
            review.text = values["Review"] as! String
            review.rating = values["Rating"] as! Int
            review.date = NSDate()
            review.tutee = User.currentUser()!
            
            review.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    if let currentUser = User.currentUser() {
                        User.objectWithoutDataWithObjectId(currentUser.objectId).fetchInBackgroundWithBlock {
                            (object: PFObject?, error: NSError?) -> Void in
                            if error == nil {
                                if let user = object as? User {
                                    user.reviews.append(review)
                                    //user.rating.append(review.rating)
                                    user.saveInBackgroundWithBlock {
                                        (succeeded: Bool, error: NSError?) -> Void in
                                        if (succeeded) {
                                            self.createAlert("Successfully posted review!", unwind: true)
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
                    self.createAlert("Unable to post review due to server error.", unwind: true)
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
