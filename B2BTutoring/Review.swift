//
//  Review.swift
//  B2BTutoring
//
//  Created by yingjun on 15/11/16.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import Foundation

class Review : PFObject, PFSubclassing {
    
    // MUST INCLUDE THIS TWO FUNCTIONS WHEN YOU SUBCLASSING FROM PFOBJECT
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String {
        return "Review"
    }
    
    @NSManaged var text: String
    @NSManaged var tutee: User
    @NSManaged var rating: Int
    @NSManaged var date: NSDate

}
