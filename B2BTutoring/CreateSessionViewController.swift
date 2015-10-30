//
//  CreateSessionViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 10/29/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit
import Eureka

class CreateSessionViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    private func initializeForm() {
//    
//    }
    private func initializeForm() {
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 16.0)
            cell.textField.font = UIFont(name: "Avenir-Medium", size: 16.0)
        }
        DateTimeInlineRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 16.0)
            cell.detailTextLabel?.font = UIFont(name: "Avenir-Medium", size: 16.0)
           // cell.datePicker = nil
            
        }
    
        form =
            TextRow() {
                $0.title = "Which is your favourite soccer player?"
                //$0.cell.textField.placeholder = "I am your father."
            }
            
            <<< TextRow() {
                //$0.title = "Which is your favourite soccer player?"
                $0.cell.textField.placeholder = "I am your father."
            }
            
            <<< TextRow("Title").cellSetup { cell, row in
                cell.textField.placeholder = row.tag
            }
            
            <<< TextRow("Location").cellSetup {
                $0.cell.textField.placeholder = $0.row.tag
            }
            
            +++
            
            SwitchRow("All-day") {
                $0.title = $0.tag
                }.onChange { [weak self] row in
                    let startDate: DateTimeInlineRow! = self?.form.rowByTag("Starts")
                    let endDate: DateTimeInlineRow! = self?.form.rowByTag("Ends")
                    
                    if row.value ?? false {
                        startDate.dateFormatter?.dateStyle = .MediumStyle
                        startDate.dateFormatter?.timeStyle = .NoStyle
                        endDate.dateFormatter?.dateStyle = .MediumStyle
                        endDate.dateFormatter?.timeStyle = .NoStyle
                    }
                    else {
                        startDate.dateFormatter?.dateStyle = .ShortStyle
                        startDate.dateFormatter?.timeStyle = .ShortStyle
                        endDate.dateFormatter?.dateStyle = .ShortStyle
                        endDate.dateFormatter?.timeStyle = .ShortStyle
                    }
                    startDate.updateCell()
                    endDate.updateCell()
                    startDate.inlineRow?.updateCell()
                    endDate.inlineRow?.updateCell()
            }
            
            <<< DateTimeInlineRow("Starts") {
                $0.title = $0.tag
                $0.value = NSDate().dateByAddingTimeInterval(60*60*24)
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowByTag("Ends")
                    if row.value?.compare(endRow.value!) == .OrderedDescending {
                        endRow.value = NSDate(timeInterval: 60*60*24, sinceDate: row.value!)
                        endRow.cell!.backgroundColor = .whiteColor()
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowByTag("All-day")
                        cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 16.0)
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .Date
                        }
                        else {
                            cell.datePicker.datePickerMode = .DateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            
            <<< DateTimeInlineRow("Ends"){
                $0.title = $0.tag
                $0.value = NSDate().dateByAddingTimeInterval(60*60*25)
                }
                .onChange { [weak self] row in
                    let startRow: DateTimeInlineRow! = self?.form.rowByTag("Starts")
                    if row.value?.compare(startRow.value!) == .OrderedAscending {
                        row.cell!.backgroundColor = .redColor()
                    }
                    else{
                        row.cell!.backgroundColor = .whiteColor()
                    }
                    row.updateCell()
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowByTag("All-day")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .Date
                        }
                        else {
                            cell.datePicker.datePickerMode = .DateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
        }
        
        
        form +++=
            
            URLRow("URL") {
                $0.placeholder = "URL"
            }
            
            <<< TextAreaRow("notes") {
                $0.placeholder = "Notes"
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
