//
//  LoginConfirmationViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 10/26/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit

class LoginConfirmationViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        enteredCode += sender.currentTitle!
        if enteredCode.characters.count == 4 {
            print("Entered Code = " + enteredCode)
            // segue to LoginProfileViewController
            performSegueWithIdentifier("Show Create Profile", sender: self)
        }

    }
    
    @IBAction func deleteDigit(sender: UIButton) {
        if enteredCode.characters.count > 0 {
            display.text = String(enteredCode.characters.dropLast())
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
    
    var enteredCode: String {
        get {
            return display.text!
        }
        set {
            display.text = newValue
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
