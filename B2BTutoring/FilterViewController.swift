//
//  FilterViewController.swift
//  B2BTutoring
//
//  Created by yingjun on 15/11/17.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import UIKit
import Eureka

class FilterViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum Category : String, CustomStringConvertible {
        case Art = "Art"
        case Cars_and_motorcycles = "Cars and motorcycles"
        case Cooking = "Cooking"
        case Design = "Design"
        case DIY_and_crafts = "DIY_and_crafts"
        case Film = "Film"
        case Health = "Health"
        case Music = "Music"
        case Photography = "Photography"
        case Sports = "Sports"
        
        var description : String { return rawValue }
        
        static let allValues = [Art, Cars_and_motorcycles, Cooking, Design, DIY_and_crafts, Film, Health, Music, Photography, Sports]
    }
    
    private func initializeForm() {
        let font = UIFont(name: "Avenir-Medium", size: 16.0)
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.textField.font = font
        }
        
        NameRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.textField.font = font
        }        
        
        DateTimeInlineRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        PickerInlineRow<Category>.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        DecimalRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
            cell.textField.font = font
        }
        
        SwitchRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = font
        }
        
        
        form =
            
            Section("Basic")
            
            <<< PickerInlineRow<Category>("Category") { (row : PickerInlineRow<Category>) -> Void in
                row.title = "Category"
                row.options = Category.allValues
                row.value = row.options[0]
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
                    cell.datePicker.datePickerMode = .DateAndTime
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
                        cell.datePicker.datePickerMode = .DateAndTime
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
    
            <<< DecimalRow("Distance") {
                $0.title = "Distance(km)"
                $0.cell.textField.placeholder = "100"
            }
            
            <<< SwitchRow("Open"){
                $0.title = "Show open session only"
            }
            
            +++ Section("Tutor")
            
            <<< NameRow("First"){
                $0.title =  "First Name"
                $0.cell.textField.placeholder = "Leo"
            }
            
            <<< NameRow("Last"){
                $0.title =  "Last Name"
                $0.cell.textField.placeholder = "Luo"
            }
            
            <<< DecimalRow("Rating") {
                $0.title = "Rating over"
                $0.cell.textField.placeholder = "5"
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
