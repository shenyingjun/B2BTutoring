//
//  Date.swift
//  B2BTutoring
//
//  Created by Reggie Huang on 11/10/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

//need to do this ::import the parse PFObject+Subclass.h in Objective-C bridging header
//#import <Parse/PFObject+Subclass.h>

// here is a extension for dates
class Date {
    
    class func from(year:Int, month:Int, day:Int) -> NSDate {
        let c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        let gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        let date = gregorian!.dateFromComponents(c)
        return date!
    }
    
    class func parse(dateStr:String, format:String="yyyy-MM-dd") -> NSDate {
        let dateFmt = NSDateFormatter()
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