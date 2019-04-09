//
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
    
    // table view
    @IBOutlet weak var barTableView: UITableView!
    
    // bars
    var bars = [Bar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbFire = Firestore.firestore().collection("bars")
        dbFire.addDocument(data: ["Max": "Hey"])
        
        // Do any additional setup after loading the view.
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
        
        let cell = barTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let cell = cell as? BarTableViewCell {
            cell.barTitleLabel.text = bar.name
            cell.BarDescLabel.text = bar.openingTime
        }
        return cell
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
