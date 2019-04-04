//  BarListViewController.swift
//  BingeCapstoneProject
//
//  Created by Brock Gibson on 2/16/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestore

class BarListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // table view iboutlet
    @IBOutlet weak var barsTableView: UITableView!
    
    var db: Firestore!
    
    var bars = [Bar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        pullData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "barCell", for: indexPath)
        return cell
    }

    func pullData() {
        
        
        db.collection("bars_04_02_2019").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    var name = document.data()["name"] as! String
                    var hours = document.data()["hoursOpen"] as! String
                    var lat: Double = 0.0
                    var lon: Double = 0.0
                    if let coords = document.get("coords") {
                        let point = coords as! GeoPoint
                        lat = point.latitude
                        lon = point.longitude
                        print(lat, lon) //here you can let coor = CLLocation(latitude: longitude:)
                    }

                    self.bars.append(Bar(name: name, date: Date(), latitude: lat, longitude: lon, openingTime: hours, deals: []))
                    print(self.bars)
                }
            }
        }
        
        for bar in bars {
            print(bar.name)
        }
    }
    
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
