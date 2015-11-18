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
    
    @NSManaged var firstname: String
    @NSManaged var lastname: String
    @NSManaged var intro: String?
    @NSManaged var rating: Double
    @NSManaged var profileImage: PFFile
    @NSManaged var backgroundImage: PFFile?
    @NSManaged var tutorSessions: [Session]?
    @NSManaged var tuteeSessions: [Session]?
    @NSManaged var followSessions: [Session]?
    @NSManaged var interests: [String:String]
    
    private func retrieveSession(s: Session) -> Session? {
        var mySession: Session
        do {
            try mySession = s.fetch()
            return mySession
        } catch {
            print("Error retrieving session")
            return nil
        }
    }
    
    func getOngoingTutorSessions() -> [Session] {
        var ongoingSessions = [Session]()
        if self.tutorSessions != nil {
            print(self.tutorSessions!)
            for session in self.tutorSessions! {
                if let mySession = retrieveSession(session) {
                    if !mySession.expired() {
                        ongoingSessions.append(mySession)
                    }
                }
            }
        }
        return ongoingSessions
    }
    
    func getOngoingTuteeSessions() -> [Session] {
        var ongoingSessions = [Session]()
        if self.tuteeSessions != nil {
            for session in self.tuteeSessions! {
                if let mySession = retrieveSession(session) {
                    if !mySession.expired() {
                        ongoingSessions.append(mySession)
                    }
                }
            }
        }
        return ongoingSessions
    }
    
    func getPassedTutorSessions() -> [Session] {
        var passedSessions = [Session]()
        if self.tutorSessions != nil {
            for session in self.tutorSessions! {
                if let mySession = retrieveSession(session) {
                    if mySession.expired() {
                        passedSessions.append(mySession)
                    }
                }
            }
        }
        return passedSessions
    }
    
    func getPassedTuteeSessions() -> [Session] {
        var passedSessions = [Session]()
        if self.tuteeSessions != nil {
            for session in self.tuteeSessions! {
                if let mySession = retrieveSession(session) {
                    if mySession.expired() {
                        passedSessions.append(mySession)
                    }
                }
            }
        }
        return passedSessions
    }

}
