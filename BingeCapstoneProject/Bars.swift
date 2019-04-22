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
    
//    class func fetchAllBars() -> [Bar] {
//        
//        var bars = [Bar]()
//        
//        let settings = FirestoreSettings()
//        Firestore.firestore().settings = settings
//        db = Firestore.firestore()
//        
//        db.collection("bars_04_02_2019").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    
//                    let name = document.data()["name"] as! String
//                    let hours = document.data()["hoursOpen"] as! String
//                    let deals = document.data()["deals"] as? Array ?? [""]
//                    
//                    var lat: Double = 0.0
//                    var lon: Double = 0.0
//                    if let coords = document.get("coords") {
//                        let point = coords as! GeoPoint
//                        lat = point.latitude
//                        lon = point.longitude
//                    }
//                    
//                    let bar = Bar(name: name, date: Date(), latitude: lat, longitude: lon, openingTime: hours, deals: [])
//                    
//                    bars.append(bar)
//                    print(bar.name)
//                }
//            }
//        }
//        
//        return bars
//    }
    
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
