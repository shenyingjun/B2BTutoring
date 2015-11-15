//
//  Query.swift
//  B2BTutoring
//
//  Created by Shegnqian Liu on 11/23/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import Parse
import Foundation

/*
 *   A PFQuery Wrapper class. Since query is ansynchronusly passed, we do our staff
 *   such us updating the UI in the block function.
 *   Example Call:
 *
     getPFObjectsWhoseKeyContainsValue("Session", key:"tag", value: "tag1", block: {
        (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // do staff
                for object in objects!
                {
                    print(object.valueForKey("tag"))
                }
            }
      })
  *
  */

class Query{
    
    /*
     * Get all PFObjects of one class, and do staff with the results
     *
     */
    func getPFObjectsByClassName(class_name: String, block: PFQueryArrayResultBlock){
    let query = PFQuery(className: class_name)
    query.findObjectsInBackgroundWithBlock(block)
    }
    
    /*
     * Get all PFObjects of one class, whose particular key is equal to the value 
     * specified and do staff with the results
     *
     */
    func getPFObjectsWhoseKeyIsValue(class_name: String, key: String, value: String, block:PFQueryArrayResultBlock){
        let query = PFQuery(className: class_name)
        query.whereKey(key, equalTo: value);
        query.findObjectsInBackgroundWithBlock(block)
    }
    
    /*
     * Get all PFObjects of one class, whose particular key is equal to one of the 
     * values specified and do staff with the results
     *
     */
    func getPFObjectsWhoseKeyIsOneOfValues(class_name: String, key: String, values: [String], block:PFQueryArrayResultBlock) {
        let query = PFQuery(className: class_name)
        query.whereKey(key, containedIn: values)
        query.findObjectsInBackgroundWithBlock(block)
    }
    
    /*
     * Get all PFObjects of one class, whose particular key contains the
     * value specified and do staff with the results
     *
     */
    func getPFObjectsWhoseKeyContainsValue(class_name: String, key: String, value: String, block:PFQueryArrayResultBlock){
        let query = PFQuery(className: class_name)
        query.whereKey(key, containsString: value)
        query.findObjectsInBackgroundWithBlock(block)
    }

    

}