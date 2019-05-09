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

protocol BarDataUser {
    var barData:BarDatabaseController!{get set}
}


class BarDatabaseController:BarDataService{
    /*
     Database Instance
     Bars Currently Loaded
     */
    
    let databaseUrl = "bars_04_02_2019"
    var db: Firestore!
    var bars:Set<Bar>
    var selectedBar:Bar?
    
    init() {
        bars = Set<Bar>()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        fetchAllBars(){ completeList in
            print(completeList.count)
        }
    }
    
//    func updateBarList(){
//        let getBars = pullData()
//        for bar in getBars(){
//            self.bars.insert(bar)
//        }
//    }
    
    func pullData(){
        //Clear bar set of all entries
//        bars.removeAll()
        //Load bars for database and create structs from data
        db.collection(databaseUrl).getDocuments(){[weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
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
                    
                    print("Adding bar \(bar.name)")
                    self?.bars.insert(bar)
                    print(self?.bars.count ?? 0.0)
                }
            }
        }
//        print(self.bars.count)
    }
}

protocol BarDataService {}

extension BarDataService {
    
    var firestore: Firestore { return Firestore.firestore() }
    
    func fetchBar(withId id: String, completion: @escaping (Bar?) -> Void){
        
        let docRef = firestore.collection("databaseUrl").document(id)
        docRef.getDocument { docSnap, error in
            
            guard error == nil, let doc = docSnap, doc.exists == true else {
                print(error)
                return
            }
            
            let decoder = JSONDecoder()
            
            //Make a mutable copy of the NSDictionary
            var dict = doc.data()
            for (key, value) in dict! {
                
                //We need to check if the value is a Date (timestamp) and parse it as a string, since you cant serialize a Date. This might be true for other types you serverside.
                if let value = value as? Date {
                    let formatter = DateFormatter()
                    dict?[key] = formatter.string(from: value)
                }
            }
            //Serialize the Dictionary into a JSON Data representation, then decode it using the Decoder().
            
            if let data = try?  JSONSerialization.data(withJSONObject: dict!, options: []) {
                let bar = try? decoder.decode(Bar.self, from: data)
                completion(bar)
            }
        }
    }
    
    func fetchAllBars(completion: @escaping (Set<Bar>) -> Void){
        var list = Set<Bar>()
        firestore.collection("databaseUrl").getDocuments()
        { docSnap, error in
            
            guard error == nil, let doc = docSnap else {
                print(error!)
                return
            }
            
            for document in doc.documents {
                var dict = document.data()
                for (key, value) in dict {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict[key] = formatter.string(from: value)
                    }
                }
                
            let decoder = JSONDecoder()
            //Serialize the Dictionary into a JSON Data representation, then decode it using the Decoder().
            
            if let data = try?  JSONSerialization.data(withJSONObject: dict, options: []) {
                let bar = try? decoder.decode(Bar.self, from: data)
                list.insert(bar!)
            }
        }
            completion(list)
    }
}
}
