//
//  Bars.swift
//  BingeCapstoneProject
//
//  Created by Brock Gibson on 3/14/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
//Data Model for Bar Lists

var db: Firestore!


class Bar {
    
    let name: String
    let date: Date
    let latitude: Double
    let longitude: Double
    let openingTime: String
    let imageURL: String
    var deals = [Deal]()

    init(name: String, date: Date, latitude: Double, longitude: Double, openingTime: String, imageURL: String, deals: [Deal]) {
        self.name = name
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.openingTime = openingTime
        self.imageURL = imageURL
        self.deals = deals
    }
}

class Deal {
    let hours: String
    let deals: [String]
    
    init(hours: String, deals: [String]) {
        self.hours = hours
        self.deals = deals
    }
    
    class func loadDeals(_ deals: [String]) -> [Deal]{
        
        var dealsArray: [Deal] = []
        
        let trigger = CharacterSet(charactersIn: "$")
        var hours: String
        var dealsStringArray: [String] = []
        
        for deal in deals {
            if let test = deal.rangeOfCharacter(from: trigger) {
                print("found money sign")
                
                dealsStringArray.append(deal)
                
            } else {
                print("no money sign")
                
                hours = deal
                
                if dealsStringArray.count > 0 {
                    dealsArray.append(Deal(hours: hours, deals: dealsStringArray))
                    dealsStringArray = []
                    hours = ""
                }
            }
        }
        
        return dealsArray
    }
}
