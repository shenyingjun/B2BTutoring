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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
