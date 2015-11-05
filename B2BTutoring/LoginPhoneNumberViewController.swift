//
//  LoginPhoneNumberViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 10/25/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit

class LoginPhoneNumberViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var info: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        if enteredDigits.characters.count < 10 {
            enteredDigits += sender.currentTitle!
        }

    }
    
    func sendConfirmationCode() {
        print("TODO: send confirmation code.")
    }
    
    @IBAction func confirmNumber(sender: UIButton) {
        if enteredDigits.characters.count == 10 {
            print("Phone Number = " + enteredDigits)
            sendConfirmationCode()
            performSegueWithIdentifier("Show Confirmation", sender: self)
        } else {
            info.text = "INVALID PHONE NUMBER"
            info.textAlignment = NSTextAlignment.Center
        }
    }
    
    @IBAction func deleteDigit(sender: UIButton) {
        if enteredDigits.characters.count > 0 {
            enteredDigits = String(enteredDigits.characters.dropLast())
        }
    }
    
    var enteredDigits: String {
        get {
            return display.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        }
        set {
            let count = newValue.characters.count
            if count <= 3 {
                display.text = newValue
            } else if count <= 6 {
                let breakIndex = newValue.startIndex.advancedBy(3)
                display.text = newValue.substringToIndex(breakIndex) + " " + newValue.substringFromIndex(breakIndex)
            } else {
                let firstBreakIndex = newValue.startIndex.advancedBy(3)
                let secondBreakIndex = newValue.startIndex.advancedBy(6)
                display.text = newValue.substringToIndex(firstBreakIndex) + " " + newValue.substringWithRange(Range(start: firstBreakIndex, end: secondBreakIndex)) + " " + newValue.substringFromIndex(secondBreakIndex)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
