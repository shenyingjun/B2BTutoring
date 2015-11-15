//
//  LoginPhoneNumberViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 10/25/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit

class LoginPhoneNumberViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        if enteredDigits.characters.count < 10 {
            enteredDigits += sender.currentTitle!
        }
    }
    
    @IBAction func deleteDigit(sender: UIButton) {
        if enteredDigits.characters.count > 0 {
            enteredDigits = String(enteredDigits.characters.dropLast())
        }
    }
    
    @IBAction func confirmNumber(sender: UIButton) {
        if enteredDigits.characters.count == 10 {
            performSegueWithIdentifier("Show Confirmation", sender: self)
        } else {
            animateOnError()
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

    func animateOnError() {
        // shake label to indicate error
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.07)
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(display.center.x - 10, display.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(display.center.x + 10, display.center.y))
        CATransaction.setCompletionBlock { () -> Void in
            self.enteredDigits = ""  // clear label
            self.message.text = "PLEASE ENTER A VALID PHONE NUMBER"
        }
        display.layer.addAnimation(animation, forKey: "position")
        CATransaction.commit()
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Confirmation" {
            if let destinationViewController = segue.destinationViewController as? LoginConfirmationViewController {
                destinationViewController.phoneNumber = "+1" + enteredDigits
            }
        }
    }

}
