//
//  Session.swift
//  B2BTutoring
//
//  Created by CLICC User on 11/7/15.
//  Copyright (c) 2015 Team 1. All rights reserved.
//

class Session : PFObject, PFSubclassing {
    
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
        return "Session"
    }

    @NSManaged var title: String
    @NSManaged var location: String
    @NSManaged var descrip : String
    @NSManaged var starts: NSDate
    @NSManaged var ends: NSDate

    //here change in the future
    @NSManaged var tutor: String
    @NSManaged var tutee: String
    @NSManaged var category: String
    @NSManaged var tags: String?
 // @NSManaged public var icon: PFFile!
    
    func expired() -> Bool{
        let current_date = NSDate()
        var isGreater = false
        
        if (self.ends.compare(current_date)==NSComparisonResult.OrderedAscending)
        {
            isGreater = true
        }
        return isGreater
    }
}
