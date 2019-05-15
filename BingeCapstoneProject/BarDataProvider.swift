//
//  BarDatabaseController.swift
//  BingeCapstoneProject
//
//  Created by Kolbe Weathington on 5/6/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

struct Bar:Hashable,Codable{
    let name: String
    let id:Int
    let date: Date
    let coordinate:Coordinate
    let hours: String
    let imageURL: String
    var deals:[Deal]
    
    enum CodingKeys: String, CodingKey{
        case name
        case id
        case date
        case coordinate = "coords"
        case hours = "hoursOpen"
        case imageURL
        case deals
    }
}

struct Deal:Hashable, Codable{
    let hours: String
    let deals: [String]
}

struct Coordinate:Hashable,Codable{
    var latitude:Double
    var longitude:Double
}

class BarDataProvider{
    let databaseUrl = "bars_04_02_2019"
    let db: Firestore!
    var bars:Set<Bar>?
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func pullData(){
        db.collection(databaseUrl).getDocuments(){[weak self](querySnapshot, err) in
            var barList = Set<Bar>()
            
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    let name = document.data()["name"] as! String
                    let imageURL = document.data()["imageURL"] as! String
                    let id = document.data()["id"] as! Int
                    let hours = document.data()["hoursOpen"] as! String
                    let deals = document.data()["deals"] as? Array ?? [""]
                    var location = Coordinate(latitude: 0.0, longitude: 0.0)
                    
                    if let coords = document.get("coords") {
                        let point = coords as! GeoPoint
                        location = Coordinate(latitude: point.latitude, longitude: point.longitude)
                    } else{
                        print("Failed to load coordinate.")
                    }
                    
                    var dealsArray: [Deal] = []
                    
                    let trigger = CharacterSet(charactersIn: "$")
                    var dealHours: String = ""
                    var dealsStringArray: [String] = []
                    
                    for deal in deals {
                        if let test = deal.rangeOfCharacter(from: trigger) {
                            dealsStringArray.append(deal)
                            
                        } else {
                            if dealsStringArray.count > 0 {
                                dealsArray.append(Deal(hours: dealHours, deals: dealsStringArray))
                                dealsStringArray = []
                            }
                            
                            dealHours = deal
                        }
                    }
                    
                    dealsArray.append(Deal(hours: dealHours, deals: dealsStringArray))
                    dealsStringArray = []
                    
                    let bar = Bar(name: name,id: id ,date: Date(),coordinate: location, hours: hours, imageURL: imageURL, deals: dealsArray)
                    
                    barList.insert(bar)
                }
                self?.setBars(barList)
            }
        }
    }
    
    func setBars(_ barList:Set<Bar>){
        let copy = barList
        self.bars = copy
    }
    
    func calculateDistance(_ coord:Coordinate){
        
    }
}

