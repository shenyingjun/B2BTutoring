//
//  Search.swift
//  B2BTutoring
//
//  Created by Reggie Huang on 11/17/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import Foundation

class Search {
    
    class func getPFQueryByString(name: String, searchString: String?) -> PFQuery {
        let str = searchString == nil ? "" : searchString!
        let tokens = str.componentsSeparatedByString(" ")
        var queries = [PFQuery]()
        for token in tokens {
            let queryDescription = PFQuery(className: name)
            queryDescription.whereKey("descrip", containsString: token)
            queries.append(queryDescription)
            let queryTitle = PFQuery(className: name)
            queryTitle.whereKey("title", containsString: token)
            queries.append(queryTitle)
            let queryTags = PFQuery(className: name)
            queryTags.whereKey("tags", containsString: token)
            queries.append(queryTags)
        }
        return PFQuery.orQueryWithSubqueries(queries)
    }
    
    class func getInterestPFQuery(name: String, interests: [String]) -> PFQuery {
        var queries = [PFQuery]()
        for interest in interests {
            let subQuery = PFQuery(className: name)
            subQuery.whereKey("category", equalTo: interest)
            queries.append(subQuery)
        }
        return PFQuery.orQueryWithSubqueries(queries)
    }
    
}

