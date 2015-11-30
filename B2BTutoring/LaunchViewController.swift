//
//  ViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 10/25/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit
import SVProgressHUD
import Parse

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        if User.currentUser()?.objectId == nil {
            performSegueWithIdentifier("Show Welcome", sender: nil)
        } else {
            print(User.currentUser())
            Layer.loginLayer() {
                SVProgressHUD.dismiss()
                self.performSegueWithIdentifier("Show Home", sender: nil)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

