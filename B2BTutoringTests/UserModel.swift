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
    
    
    
    
    let user1 = User()
    func testgetOngoingTutorSessions() {
        
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
        
        
        
        var mysessions = [Session]()
        
        //        User.objectWithoutDataWithObjectId(user1.objectId).fetchInBackgroundWithBlock {
        //      (object: PFObject?, error: NSError?) -> Void in
        //    if error == nil {
        //  if let user = object as? User {
        
        user1.tutorSessions.append(session1)
        user1.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in}
        
        
        XCTAssertEqual(user1.getOngoingTutorSessions(),[], "it should not have any ongoing sessions yet")
        
        mysessions.append(session2)
        user1.tutorSessions.append(session2)
                User.objectWithoutDataWithObjectId(user1.objectId).fetchInBackgroundWithBlock {
              (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
          if let user = object as? User {
        user.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in}
              XCTAssertEqual(user.getOngoingTutorSessions(),mysessions, "it should have some sessions")
            
                }}}
      
        
        mysessions.append(session3)
        user1.tutorSessions.append(session3)
        User.objectWithoutDataWithObjectId(user1.objectId).fetchInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let user = object as? User {
                    user.saveInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in}
                    XCTAssertEqual(user.getOngoingTutorSessions(),mysessions, "it should have some sessions")

                    
                }}}
        
        
        // ---------
        
        
        
        XCTAssert(true, "Pass")
    }
    
    
    
    func testgetOngoingTuteeSessions(){
        
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
        
        XCTAssertEqual(user1.getOngoingTuteeSessions(),[], "it should not have any sessions yet")
        
        var mysessions = [Session]()
        mysessions.append(session1)
        user1.tuteeSessions.append(session1)
        user1.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in}
        
        XCTAssertEqual(user1.getOngoingTuteeSessions(),[], "it should not have any ongoing sessions yet")
        
        mysessions.append(session2)
        user1.tuteeSessions.append(session2)
        User.objectWithoutDataWithObjectId(user1.objectId).fetchInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let user = object as? User {
        user.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in}
                    XCTAssertEqual(user.getOngoingTuteeSessions(),mysessions, "it should have some sessions")}}}
        
        mysessions.append(session3)
        user1.tuteeSessions.append(session3)
        User.objectWithoutDataWithObjectId(user1.objectId).fetchInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let user = object as? User {
                    user.saveInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in}
                    XCTAssertEqual(user.getOngoingTuteeSessions(),mysessions, "it should have some sessions")}}}
        XCTAssert(true, "Pass")
        
    }
    
    func testgetPassedTutorSessions(){
        
        var session1 = Session()
        session1.title = "soccer"
        session1.ends = Date.parse("2014-05-20")
        
        
        var session2 = Session()
        session2.title = "swim"
        session2.ends = Date.parse("2016-05-20")
        
        var session3 = Session()
        session3.title = "card"
        session3.ends = Date.parse("2016-05-20")
        
        XCTAssertEqual(user1.getPassedTutorSessions(),[], "it should not have any sessions yet")
        
        
        
        var mysessions = [Session]()
        mysessions.append(session1)
        
        //        User.objectWithoutDataWithObjectId(user1.objectId).fetchInBackgroundWithBlock {
        //      (object: PFObject?, error: NSError?) -> Void in
        //    if error == nil {
        //  if let user = object as? User {
        
        user1.tutorSessions.append(session1)
        User.objectWithoutDataWithObjectId(user1.objectId).fetchInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let user = object as? User {
                    user.saveInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in}
                    XCTAssertEqual(user.getPassedTutorSessions(),mysessions, "it should have some sessions")}}}
        
        
        user1.tutorSessions.append(session2)
        User.objectWithoutDataWithObjectId(user1.objectId).fetchInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let user = object as? User {
                    user.saveInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in}
                    XCTAssertEqual(user.getPassedTutorSessions(),mysessions, "it should have some sessions")}}}
        
        
        
        XCTAssert(true, "Pass")
    }
    
    func testgetPassedTuteeSessions(){
        
        
        var session1 = Session()
        session1.title = "soccer"
        session1.ends = Date.parse("2014-05-20")
        
        
        var session2 = Session()
        session2.title = "swim"
        session2.ends = Date.parse("2016-05-20")
        
        
        
        XCTAssertEqual(user1.getPassedTuteeSessions(),[], "it should not have any sessions yet")
        
        var mysessions = [Session]()
        mysessions.append(session1)
        user1.tuteeSessions.append(session1)
        User.objectWithoutDataWithObjectId(user1.objectId).fetchInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let user = object as? User {
                    user.saveInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in}
                    XCTAssertEqual(user.getPassedTuteeSessions(),mysessions, "it should have some sessions")}}}
        
        
        user1.tuteeSessions.append(session2)
        User.objectWithoutDataWithObjectId(user1.objectId).fetchInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let user = object as? User {
                    user.saveInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in}
                    XCTAssertEqual(user.getPassedTuteeSessions(),mysessions, "it should have some sessions")}}}
        
        XCTAssert(true, "Pass")
        
    }
    
    
    
}
