//
//  LoginOrSignUpViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 11/16/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginOrSignUpViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: nil, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: nil, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var phoneNumber: HoshiTextField! {
        didSet {
            phoneNumber.delegate = self
        }
    }
    
    @IBOutlet weak var password: HoshiTextField! {
        didSet {
            password.delegate = self
        }
    }
    
    var firstResponder: UIView?
    
    func textFieldDidBeginEditing(textField: UITextField) {
        firstResponder = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        firstResponder!.resignFirstResponder()
        firstResponder = nil
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        firstResponder!.resignFirstResponder()
        firstResponder = nil
        return true
    }
    
    @IBOutlet weak var message: UILabel!
    
    @IBAction func login(sender: UIButton) {
        if !isPhoneNumberValid(phoneNumber.text!) {
            message.text = "*Please enter a valid phone number*"
            phoneNumber.text = ""
        } else if password.text! == "" {
            message.text = "*Password cannot be empty*"
            password.text = ""
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let storedPhoneNumber = "+1" + phoneNumber.text!
            PFUser.logInWithUsernameInBackground(storedPhoneNumber, password:password.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                // Stop the spinner
                spinner.stopAnimating()
                
                if user != nil {
                    Layer.loginLayer() {
                        SVProgressHUD.dismiss()
                        self.firstResponder?.resignFirstResponder()
                        self.performSegueWithIdentifier("Show Home After Login", sender: self)
                    }
                } else {
                    self.message.text = "*Incorrect phone number and password combination*"
                    self.phoneNumber.text = ""
                    self.password.text = ""
                }
            }
        }
    }
    
    func isPhoneNumberValid(number: String) -> Bool {
        if number.characters.count == 10 {
            if let n = Int(number) {
                print(n)
                return true
            }
        }
        return false
    }
    
    @IBAction func signUp(sender: UIButton) {
        performSegueWithIdentifier("Show Sign Up", sender: self)
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
