import Foundation
import Parse

class UserManager {
    static let sharedManager = UserManager()
    var userCache: NSCache = NSCache()

    // MARK Query Methods
    func queryForUserWithName(searchText: String, completion: ((NSArray?, NSError?) -> Void)) {
        let query: PFQuery! = User.query()
        query.whereKey("objectId", notEqualTo: User.currentUser()!.objectId!)
        
        query.findObjectsInBackgroundWithBlock { objects, error in
            var contacts = [User]()
            if (error == nil) {
                for user: User in (objects as! [User]) {
                    if user.fullName.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
                        contacts.append(user)
                    }
                }
            }
            completion(contacts, error)
        }
    }

    func queryForAllUsersWithCompletion(completion: ((NSArray?, NSError?) -> Void)?) {
        let query: PFQuery! = User.query()
        query.whereKey("objectId", notEqualTo: User.currentUser()!.objectId!)
        query.findObjectsInBackgroundWithBlock { objects, error in
            if let callback = completion {
                callback(objects, error)
            }
        }
    }

    func queryAndCacheUsersWithIDs(userIDs: [String], completion: ((NSArray?, NSError?) -> Void)?) {
        let query: PFQuery! = User.query()
        query.whereKey("objectId", containedIn: userIDs)
        query.findObjectsInBackgroundWithBlock { objects, error in
            if (error == nil) {
                for user: User in (objects as! [User]) {
                    self.cacheUserIfNeeded(user)
                }
            }
            if let callback = completion {
                callback(objects, error)
            }
        }
    }

    func cachedUserForUserID(userID: NSString) -> User? {
        if self.userCache.objectForKey(userID) != nil {
            return self.userCache.objectForKey(userID) as! User?
        }
        return nil
    }

    func cacheUserIfNeeded(user: User) {
        if self.userCache.objectForKey(user.objectId!) == nil {
            self.userCache.setObject(user, forKey: user.objectId!)
        }
    }

    func unCachedUserIDsFromParticipants(participants: NSArray) -> NSArray {
        var array = [String]()
        for userID: String in (participants as! [String]) {
            if (userID == User.currentUser()!.objectId!) {
                continue
            }
            if self.userCache.objectForKey(userID) == nil {
                array.append(userID)
            }
        }
        
        return NSArray(array: array)
    }

    func resolvedNamesFromParticipants(participants: NSArray) -> NSArray {
        var array = [String]()
        for userID: String in (participants as! [String]) {
            if (userID == User.currentUser()!.objectId!) {
                continue
            }
            if self.userCache.objectForKey(userID) != nil {
                let user: User = self.userCache.objectForKey(userID) as! User
                array.append(user.firstName)
            }
        }
        return NSArray(array: array)
    }
    
}