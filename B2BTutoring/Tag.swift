//
//  Tag.swift
//  B2BTutoring
//
//  Created by yingjun on 15/12/18.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import Foundation

class Tag : PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String {
        return "Tag"
    }
    
    @NSManaged var text: String
    
}
