//
//  User.swift
//  B2BTutoring
//
//  Created by Reggie Huang on 11/16/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import Foundation

class User : PFUser {
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    @NSManaged var lastName: String
    @NSManaged var firstName: String
    @NSManaged var phone: String
    @NSManaged var intro: String
    @NSManaged var tutorSessions: [Session]?
    @NSManaged var tuteeSessions: [Session]?
    
    func getOngoingTutorSessions() -> [Session] {
        var ongoingSessions = [Session]()
        if self.tutorSessions != nil {
            for session in self.tutorSessions! {
                if !session.expired() {
                    ongoingSessions.append(session)
                }
            }
        }
        return ongoingSessions
    }
    
    func getOngoingTuteeSessions() -> [Session] {
        var ongoingSessions = [Session]()
        if self.tuteeSessions != nil {
            for session in self.tuteeSessions! {
                if !session.expired() {
                    ongoingSessions.append(session)
                }
            }
        }
        return ongoingSessions
    }
    
    func getPassedTutorSessions() -> [Session] {
        var passedSessions = [Session]()
        if self.tutorSessions != nil {
            for session in self.tutorSessions! {
                if session.expired() {
                    passedSessions.append(session)
                }
            }
        }
        return passedSessions
    }
    
    func getPassedTuteeSessions() -> [Session] {
        var passedSessions = [Session]()
        if self.tuteeSessions != nil {
            for session in self.tuteeSessions! {
                if session.expired() {
                    passedSessions.append(session)
                }
            }
        }
        return passedSessions
    }
}
