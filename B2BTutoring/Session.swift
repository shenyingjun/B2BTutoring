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

    @NSManaged var currentEnrollment: Int
    @NSManaged var capacity: Int
    @NSManaged var backgroundImage: PFFile
    
    @NSManaged var tutor: User
    @NSManaged var tutees: [User]
    @NSManaged var category: String
    @NSManaged var tags: String?
    
    func expired() -> Bool{
        
        if self.ends.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return true
        }
        return false
    }
    
    func isFull() -> Bool {
        return self.capacity == self.currentEnrollment
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
