//
//  Filter.swift
//  B2BTutoring
//
//  Created by Reggie Huang on 11/17/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

class Filter {
    
    var category : String
    var starts : NSDate
    var ends : NSDate
    var distance : Float?
    var firstname : String?
    var lastname : String?
    var rating : Double?
    var showOpen: Bool
    
    init(values: [String : Any?]) {
        let c = values["Category"] as! (Common.Category)
        self.category = c.description
        self.starts = values["Starts"] as! NSDate
        self.ends = values["Ends"] as! NSDate
        self.firstname = values["First"] as? String
        self.lastname = values["Last"] as? String
        if let dist = values["Distance"] as? Float {
            self.distance = dist
        } else {
            self.distance = nil
        }
        if let rating = values["Rating"] as? Float {
            self.rating = Double(rating)
        } else {
            self.rating = nil
        }
        if let isOpen = values["Open"] {
            if isOpen == nil {
                self.showOpen = false
            } else {
                self.showOpen = true
            }
        } else {
            self.showOpen = false
        }
        print(self.showOpen)
    }
}
