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
    
    // bars
    var bars = [Bar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            bars = Bar.fetchAllBars()
            barsTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailFromTable", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BarDetailViewController, let selectedRow = barsTableView.indexPathForSelectedRow {
            destination.passedBar = bars[selectedRow.row]
        }
    }

}
