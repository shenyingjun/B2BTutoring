//
//  Common.swift
//  B2BTutoring
//
//  Created by Reggie Huang on 11/18/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

class Common {
    enum Category : String, CustomStringConvertible {
        case Art = "Art"
        case Cars_and_motorcycles = "Cars and motorcycles"
        case Cooking = "Cooking"
        case Design = "Design"
        case DIY_and_crafts = "DIY_and_crafts"
        case Film = "Film"
        case Health = "Health"
        case Music = "Music"
        case Photography = "Photography"
        case Sports = "Sports"
        
        var description : String { return rawValue }
        
        static let allValues = [Art, Cars_and_motorcycles, Cooking, Design, DIY_and_crafts, Film, Health, Music, Photography, Sports]
    }
    
}

let themeColor = UIColor(red: CGFloat(3/255.0), green: CGFloat(201/255.0), blue: CGFloat(169/255.0), alpha: 1.0)

