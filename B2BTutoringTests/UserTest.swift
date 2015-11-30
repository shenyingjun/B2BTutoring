//
//  UserTest.swift
//  B2BTutoring
//
//  Created by CLICC User on 11/23/15.
//  Copyright (c) 2015 Team 1. All rights reserved.
//

import UIKit
import XCTest
import Parse
@testable import B2BTutoring

class UserTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        Parse.setApplicationId("LkLnpCvNTSBebXcglqtpzRfgRLmOCfcJInnHVXDr", clientKey: "BPfphsMDhWCnCncd1H9vvMMvDPR766AOpLGw6KYG")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    /*
    @NSManaged var firstname: String
    @NSManaged var lastname: String
    @NSManaged var intro: String?
    @NSManaged var rating: Double
    @NSManaged var profileImage: PFFile?
    @NSManaged var profileThumbnail: PFFile?
    @NSManaged var backgroundImage: PFFile?
    @NSManaged var backgroundThumbnail: PFFile?
    @NSManaged var tutorSessions: [Session]
    @NSManaged var tuteeSessions: [Session]
    @NSManaged var followSessions: [Session]
    @NSManaged var reviews: [Review]
    @NSManaged var interests: [String:String]
    
    @NSManaged var text: String
    @NSManaged var tutee: User
    @NSManaged var rating: Int
    @NSManaged var date: NSDate
    
    @NSManaged var title: String
    @NSManaged var location: String
    @NSManaged var locationGeoPoint:PFGeoPoint
    @NSManaged var descrip : String
    @NSManaged var starts: NSDate
    @NSManaged var ends: NSDate
    @NSManaged var currentEnrollment: Int
    @NSManaged var capacity: Int
    @NSManaged var backgroundImage: PFFile
    @NSManaged var tutor: User
    @NSManaged var tutees: [User]
    @NSManaged var category: String
    @NSManaged var tags: String?
    
    
    */
    
    
    
    
    func testGetReviews() {
        // This is an example of a functional test case.
        
        let user1 = User.currentUser()!
        var review1 = Review()
        review1.text = "sdf"
        XCTAssertEqual(user1.getReviews(),[], "it should not have any reviews yet")
        
        
        var myreviews = [Review]()
        myreviews.append(review1)
        
        user1.reviews = myreviews
        
        XCTAssertEqual(user1.getReviews(), myreviews, "it should have a review yet")
        
        
        
        
        // -----------------
        var session1 = Session()
        session1.title = "soccer"
        session1.ends = Date.parse("2014-05-20")
        
        
        var session2 = Session()
        session2.title = "swim"
        session2.ends = Date.parse("2016-05-20")
        
        var session3 = Session()
        session3.title = "card"
        session3.ends = Date.parse("2016-05-20")
        
        XCTAssertEqual(user1.getOngoingTutorSessions(),[], "it should not have any sessions yet")
        /*
        var mysessions = [Session]()
        mysessions.append(session1)
        User.currentUser()!.tutorSessions = mysessions
        
        XCTAssertEqual(User.currentUser()!.getOngoingTutorSessions(),[], "it should not have any ongoing sessions yet")
        
        mysessions.append(session2)
        User.currentUser()!.tutorSessions = mysessions
        
        XCTAssertEqual(User.currentUser()!.getOngoingTutorSessions(),mysessions, "it should have some sessions")
        
        mysessions.append(session3)
        User.currentUser()!.tutorSessions = mysessions
        
        XCTAssertEqual(User.currentUser()!.getOngoingTutorSessions(),mysessions, "it should have some sessions")
        // ---------
        
        */
        
        XCTAssert(true, "Pass")
    }
    

    
   /* func testgetOngoingTuteeSessions(){
        
        user1.firstname = "Frank"
        
        var session1 = Session()
        session1.title = "soccer"
        session1.ends = Date.parse("2014-05-20")
        
        
        var session2 = Session()
        session2.title = "swim"
        session2.ends = Date.parse("2016-05-20")
        
        var session3 = Session()
        session3.title = "card"
        session3.ends = Date.parse("2016-05-20")
        
        XCTAssertEqual(user1.getOngoingTutorSessions(),[], "it should not have any sessions yet")
        
        var mysessions = [Session]()
        mysessions.append(session1)
        user1.tuteeSessions = mysessions
        
        XCTAssertEqual(user1.getOngoingTutorSessions(),[], "it should not have any ongoing sessions yet")
        
        mysessions.append(session2)
        user1.tuteeSessions = mysessions
        
        XCTAssertEqual(user1.getOngoingTutorSessions(),mysessions, "it should have some sessions")
        
        mysessions.append(session3)
        user1.tuteeSessions = mysessions
        
        XCTAssertEqual(user1.getOngoingTutorSessions(),mysessions, "it should have some sessions")
    }*/
    
}
