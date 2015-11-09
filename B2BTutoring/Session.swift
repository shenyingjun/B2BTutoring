//
//  Session.swift
//  B2BTutoring
//
//  Created by CLICC User on 11/7/15.
//  Copyright (c) 2015 Team 1. All rights reserved.
//




//need to do this ::import the parse PFObject+Subclass.h in Objective-C bridging header
//#import <Parse/PFObject+Subclass.h>
import Parse

// here is a extension for dates
class Date {
    
    class func from(year:Int, month:Int, day:Int) -> NSDate {
        var c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        var gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        var date = gregorian!.dateFromComponents(c)
        return date!
    }
    
    class func parse(dateStr:String, format:String="yyyy-MM-dd") -> NSDate {
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(dateStr)!
    }
}
// useage
//var date = Date.parse("2014-05-20")
//var date = Date.from(year: 2014, month: 05, day: 20)

//NSDate *date1;
//NSDate *date2;
//Then the following comparison will tell which is earlier/later/same:

/*
if ([date1 compare:date2] == NSOrderedDescending) {
    NSLog(@"date1 is later than date2");
} else if ([date1 compare:date2] == NSOrderedAscending) {
    NSLog(@"date1 is earlier than date2");
} else {
    NSLog(@"dates are the same");
}

*/
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

    @NSManaged var name: String!
    @NSManaged var descrip : String!
    @NSManaged var date: NSDate!

    //here change in the future
    @NSManaged var tutor: String!
    @NSManaged var tutee: String!
 // @NSManaged public var icon: PFFile!
    
    func expired() -> Bool{
        let current_date = NSDate()
        var isGreater = false
        
        if (self.date.compare(current_date)==NSComparisonResult.OrderedAscending)
        {
            isGreater = true
        }
        return isGreater
    }
}
