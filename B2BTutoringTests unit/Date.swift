//
//  Date Test.swift
//  B2BTutoring
//
//  Created by CLICC User on 11/23/15.
//  Copyright (c) 2015 Team 1. All rights reserved.
//

import UIKit
import XCTest
@testable import B2BTutoring

class Date_Test: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        
        var date1 = Date.parse("2014-05-20")
        var date2 = Date.from(2014,month: 06, day: 20)
        
        XCTAssertTrue(date1.compare(date2) == NSComparisonResult.OrderedAscending, "Date1 is earlier")
        XCTAssertFalse(date1.compare(date2) == NSComparisonResult.OrderedDescending, "Date2 is later")
        XCTAssert(true, "Pass")
    }
    
    
    
}
