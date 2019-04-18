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
    
    // database for pulling data
    var db: Firestore!
    
    // table view iboutlet
    @IBOutlet weak var barsTableView: UITableView!
    
    // bars
    var bars = [Bar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        barsTableView.dataSource = self
        barsTableView.delegate = self
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        pullData()
        DispatchQueue.main.async {
            self.barsTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func pullData() {
        db.collection("bars_04_02_2019").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {

                    let name = document.data()["name"] as! String
                    let hours = document.data()["hoursOpen"] as! String
                    let deals = document.data()["deals"] as? Array ?? [""]

                    var lat: Double = 0.0
                    var lon: Double = 0.0
                    if let coords = document.get("coords") {
                        let point = coords as! GeoPoint
                        lat = point.latitude
                        lon = point.longitude
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

                    let bar = Bar(name: name, date: Date(), latitude: lat, longitude: lon, openingTime: hours, deals: dealsArray)
                    
                    self.bars.append(bar)
                }
            }
            DispatchQueue.main.async {
                self.barsTableView.reloadData()
            }
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "barCell"
        let bar = bars[indexPath.row]
        
        let cell = barsTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let cell = cell as? BarTableViewCell {
            cell.barTitleLabel.text = bar.name
            cell.BarDescLabel.text = bar.openingTime
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BarDetailViewController, let selectedRow = barsTableView.indexPathForSelectedRow {
            destination.passedBar = bars[selectedRow.row]
        }
    }

}
