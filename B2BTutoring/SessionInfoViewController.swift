//
//  SessionInfoViewController.swift
//  B2BTutoring
//
//  Created by yingjun on 15/11/4.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import UIKit

class SessionInfoViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tutorNameLabel: UILabel!
    @IBOutlet weak var tutorImageButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeSessionStatus(sender: UIButton) {
        //join, quit or follow a session
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
