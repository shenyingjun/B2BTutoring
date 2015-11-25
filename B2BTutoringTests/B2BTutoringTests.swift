import UIKit
import XCTest
@testable import B2BTutoring

class SessionTest: XCTestCase {
    
    let constantTitle : String = "title";
    let constantDescription : String = "description";
    let constantLocation : String = "location";
    
    let constantStartTime : NSDate = NSDate(timeIntervalSinceNow: 0)
    let constantEndTime : NSDate = NSDate(timeIntervalSinceNow: 3600)
    
    let constantEnrollment = 1
    let constantCapacity = 1
    
    //  let AppUser: AnyClass! = NSBundle.mainBundle().classNamed("PFUser")
    
    let constantCategory : String = "category"
    // let constantTags : String = "tag"
    
    
    
    override func setUp() {
        super.setUp()
        //Parse.setApplicationId("sIZN7Eo4sl6tR5ZdI04qIEKf5wm1QJN92jBxTLKb", clientKey: "IfKhgzcCazKuLPJCrQJwhDavQPTX59G0fo91bvuf")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
    }
    
    func testComparison() {
        
        var test = Session()
        test.title = constantTitle
        test.descrip = constantDescription
        test.location = constantLocation
        test.starts = constantStartTime
        test.ends = constantEndTime
        test.currentEnrollment = constantEnrollment
        test.capacity = constantCapacity
        test.category = constantCategory
        
        XCTAssertEqual(constantTitle, test.title, "title should match up")
        XCTAssertEqual(constantDescription, test.descrip, "description should match up")
        XCTAssertEqual(constantLocation, test.location, "location should match up")
        XCTAssertEqual(constantStartTime, test.starts, "start time should match up")
        XCTAssertEqual(constantEndTime, test.ends, "end time should match up")
        XCTAssertEqual(constantCategory, test.category, "category should match up")
        XCTAssertEqual(constantCapacity, test.capacity, "Capacity should match up")
        XCTAssertEqual(constantEnrollment, test.currentEnrollment, "currentEnrollment should match up")
        
        test.title = "S"
        XCTAssertNotEqual(constantTitle, test.title, "they should be different")
        
        test.descrip = "i am different now"
        XCTAssertNotEqual(constantDescription, test.descrip, "they should be different")
        
        test.starts = NSDate(timeIntervalSinceNow: 11)
        XCTAssertNotEqual(constantStartTime, test.starts, "they should be different")
        XCTAssert(true, "Pass")
        
    }
    
    
    func testMutationTest(){
        var test = Session()
        
        test.title = constantTitle
        test.descrip = constantDescription
        test.location = constantLocation
        test.starts = constantStartTime
        test.ends = constantEndTime
        test.currentEnrollment = constantEnrollment
        test.capacity = constantCapacity
        test.category = constantCategory
        
        test.title = "S"
        XCTAssertNotEqual(constantTitle, test.title, "they should be different")
        
        test.descrip = "i am different now"
        XCTAssertNotEqual(constantDescription, test.descrip, "they should be different")
        
        test.starts = NSDate(timeIntervalSinceNow: 11)
        XCTAssertNotEqual(constantStartTime, test.starts, "they should be different")
        XCTAssert(true, "Pass")
        
    }
    
    
    func testExpireTest(){
        var test = Session()
        
        test.title = constantTitle
        test.descrip = constantDescription
        test.location = constantLocation
        test.starts = constantStartTime
        test.ends = constantEndTime
        test.currentEnrollment = constantEnrollment
        test.capacity = constantCapacity
        test.category = constantCategory
        XCTAssertFalse(test.expired(),"date has not expired!")
        
        test.ends = Date.parse("2014-05-20")
        XCTAssertTrue(test.expired(),"date has expired!")
        
        test.ends = NSDate(timeIntervalSinceNow: 0)
        XCTAssertTrue(test.expired(),"date has expired!")
        XCTAssert(true, "Pass")
    }
    
    func testCapacityTest(){
        var test = Session()
        
        test.title = constantTitle
        test.descrip = constantDescription
        test.location = constantLocation
        test.starts = constantStartTime
        test.ends = constantEndTime
        test.currentEnrollment = constantEnrollment
        test.capacity = constantCapacity
        test.category = constantCategory
        XCTAssertTrue(test.isFull(),"current session is full")
        test.capacity = 2
        
        XCTAssertFalse(test.isFull(),"current session is not full")
        
        test.currentEnrollment = 3
        XCTAssertTrue(test.isFull(),"current session is over capacity")
        XCTAssert(true, "Pass")
    }
    
    
}