//
//  LoginProfileContViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 11/17/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginProfileContViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    // user info
    var phoneNumber: String!
    var firstname: String!
    var lastname: String!
    var email: String!
    var password: String!
    var photo: UIImage!
    
    @IBOutlet weak var category1: HoshiTextField! {
        didSet {
            category1.inputView = pickerView1
            category1.delegate = self
        }
    }
    
    @IBOutlet weak var category2: HoshiTextField! {
        didSet {
            category2.inputView = pickerView2
            category2.delegate = self
        }
    }
    
    @IBOutlet weak var category3: HoshiTextField! {
        didSet {
            category3.inputView = pickerView3
            category3.delegate = self
        }
    }
    
    @IBOutlet weak var hashtag1: HoshiTextField! {
        didSet {
            hashtag1.delegate = self
        }
    }
    
    @IBOutlet weak var hashtag2: HoshiTextField! {
        didSet {
            hashtag2.delegate = self
        }
    }
    
    @IBOutlet weak var hashtag3: HoshiTextField! {
        didSet {
            hashtag3.delegate = self
        }
    }
    
    @IBOutlet weak var introduction: HoshiTextField! {
        didSet {
            introduction.delegate = self
        }
    }
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var slidingView: UIView!
    
    var pickerView1 = UIPickerView()
    var pickerView2 = UIPickerView()
    var pickerView3 = UIPickerView()
    var pickOption = ["Art", "DIY", "Music", "Photography", "Sports"]
    var firstResponder: UIView?
    
    @IBAction func createUser(sender: UIButton) {
        signUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView1.delegate = self
        pickerView1.backgroundColor = UIColor.whiteColor()
        
        pickerView2.delegate = self
        pickerView2.backgroundColor = UIColor.whiteColor()
        
        pickerView3.delegate = self
        pickerView3.backgroundColor = UIColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissPicker")
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - PickerView
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel(frame: CGRectMake(0, 0, pickerView.frame.size.width, 40))
        label.backgroundColor = UIColor.whiteColor()
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.boldSystemFontOfSize(15.0)
        label.text = pickOption[row]
        label.textAlignment = .Center
        return label
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(40.0)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1 {
            category1.text = pickOption[row]
        } else if pickerView == pickerView2 {
            category2.text = pickOption[row]
        } else if pickerView == pickerView3 {
            category3.text = pickOption[row]
        }

        let label = pickerView.viewForRow(row, forComponent: component) as! UILabel
        label.textColor = UIColor(red: CGFloat(3/255.0), green: CGFloat(201/255.0), blue: CGFloat(169/255.0), alpha: 1.0)
    }

    func dismissPicker() {
        firstResponder?.resignFirstResponder()
        firstResponder = nil
    }
    
    // MARK: - TextField
    func textFieldDidBeginEditing(textField: UITextField) {
        firstResponder = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        firstResponder = nil
        return true
    }
    
    func keyboardShow(notification: NSNotification) {
        let dict = notification.userInfo!
        var r = (dict[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        r = slidingView.convertRect(r, fromView:nil)
        if let f = firstResponder?.frame {
            let y : CGFloat = f.maxY + r.size.height - slidingView.bounds.height + 5
            if r.origin.y < f.maxY {
                topConstraint.constant = -y
                bottomConstraint.constant = -y
                view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardHide(notification: NSNotification) {
        topConstraint.constant = 0
        bottomConstraint.constant = 0
        view.layoutIfNeeded()
    }

    // MARK: - Sign Up
    func signUp() {
        let user = User()
        user.username = phoneNumber
        user.password = password
        user.email = email
        user.firstname = firstname
        user.lastname = lastname
        user.intro = introduction.text!
        user.rating = 5.0
        if category1.text != "" && hashtag1.text != "" {
            user.interests[category1.text!] = hashtag1.text!
        }
        if category2.text != "" && hashtag2.text != "" {
            user.interests[category2.text!] = hashtag2.text!
        }
        if category3.text != "" && hashtag3.text != "" {
            user.interests[category3.text!] = hashtag3.text!
        }

        let profileImage = Toucan(image: photo).resize(CGSize(width: 600, height: 600), fitMode: Toucan.Resize.FitMode.Crop).image
        let profileThumbnail = Toucan(image: photo).resize(CGSize(width: 120, height: 120), fitMode: Toucan.Resize.FitMode.Crop).image
        let profileImageData = UIImageJPEGRepresentation(profileImage, 0.8)
        let profileThumbnailData = UIImageJPEGRepresentation(profileThumbnail, 0.8)
        
        // Run a spinner to show a task in progress
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        spinner.startAnimating()
        
        // Sign up the user asynchronously
        user.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
            
            // Stop the spinner
            spinner.stopAnimating()
            
            if ((error) != nil) {
                let alertController = UIAlertController(title: "B2BTutoring", message:
                    "Error", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // upload profile image and thumbnail
                user.profileImage = PFFile(name: "profile.jpg", data: profileImageData!)!
                user.profileThumbnail = PFFile(name: "profileThumbnail.jpg", data: profileThumbnailData!)!
                user.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    
                    if error == nil {
                        //take user home
                        print("data uploaded")
                        Layer.loginLayer() {
                            SVProgressHUD.dismiss()
                            self.performSegueWithIdentifier("Show Home After Signup", sender: self)
                        }
                    } else {
                        print(error)
                    }
                })
            }
        })
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         //firstResponder?.resignFirstResponder()
    }

}
