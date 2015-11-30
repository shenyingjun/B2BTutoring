//
//  Session.swift
//  B2BTutoring
//
//  Created by Reggie Huang on 11/16/15.
//  Copyright © 2015 Team 1. All rights reserved.
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
    @NSManaged var locationGeoPoint:PFGeoPoint
    @NSManaged var descrip : String
    @NSManaged var starts: NSDate
    @NSManaged var ends: NSDate

    @NSManaged var currentEnrollment: Int  // not used
    @NSManaged var capacity: Int
    @NSManaged var backgroundImage: PFFile
    
    @NSManaged var tutor: User
    @NSManaged var tutees: [User]
    @NSManaged var followers: [User]
    @NSManaged var category: String
    @NSManaged var tags: String?
    
    @NSManaged var conversationId: String?
    
    func expired() -> Bool{
        if self.ends.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return true
        }
        return false
    }
    
    func isFull() -> Bool {
        return self.capacity == self.tutees.count
    }
    
    func addTutee(tutee: User) {
        if !isFull() {
            tutees.append(tutee)
        }
    }
    
    func addFollower(follower: User) {
        followers.append(follower)
    }
    
    func removeTutee(tutee: User) {
        for t in tutees {
            if t.objectId == tutee.objectId {
                tutees.removeAtIndex(tutees.indexOf(t)!)
            }
        }
    }
    
    func removeFollower(follower: User) {
        for f in followers {
            if f.objectId == follower.objectId {
                followers.removeAtIndex(followers.indexOf(f)!)
            }
        }
    }
    
    func isTutee(user: User) -> Bool {
        for t in tutees {
            if t.objectId == user.objectId {
                return true
            }
        }
        return false
    }
    
    func isFollower(user: User) -> Bool {
        for f in followers {
            if f.objectId == user.objectId {
                return true
            }
        }
        return false
    }
    
    func getSortingScore(currentLocation : PFGeoPoint?) -> Double {
        var score : Double
        do {
            let tutor = try self.tutor.fetch()
            if currentLocation != nil {
                let geoScore = currentLocation!.distanceInMilesTo(self.locationGeoPoint)
                score = 1 / geoScore * tutor.rating / 5
            } else {
                score = tutor.rating / 5
            }
        } catch {
            if currentLocation != nil {
                let geoScore = currentLocation!.distanceInMilesTo(self.locationGeoPoint)
                score = 1 / geoScore
            } else {
                score = 0
            }
        }
        return score
    }
}
