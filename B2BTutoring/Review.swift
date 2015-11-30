//
//  Review.swift
//  B2BTutoring
//
//  Created by yingjun on 15/11/16.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import Foundation

class Review : PFObject, PFSubclassing {
    
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
        return "Review"
    }
    
    @NSManaged var text: String
    @NSManaged var tutee: User
    @NSManaged var rating: Int
    @NSManaged var date: NSDate
    @NSManaged var tutorId: String
    
    private func retrieveTutee(u: User) -> User? {
        var myTutee: User
        do {
            try myTutee = u.fetch()
            return myTutee
        } catch {
            print("Error retrieving session")
            return nil
        }
    }
    
    private static func retrieveRieview(r: Review) -> Review? {
        var myReview: Review
        do {
            try myReview = r.fetch()
            return myReview
        } catch {
            print("Error retrieving review")
            return nil
        }
    }
    
    func getTutee() -> User {
        return retrieveTutee(self.tutee)!
    }
    
    static func getReviewsForUser(user: User) -> [Review] {
        var allReviews = [Review]()
        let query = PFQuery(className: "Review").whereKey("tutorId", equalTo: user.objectId!)
        query.findObjectsInBackgroundWithBlock { (reviews: [PFObject]?, error: NSError?) -> Void in
            for r in reviews! {
                let review = r as! Review
                let myReview = retrieveRieview(review)
                allReviews.append(myReview!)
            }
            //return allReviews
        }
 
        return allReviews
    }

}
