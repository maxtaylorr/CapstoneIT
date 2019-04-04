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

class BarListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbFire = Firestore.firestore().collection("bars")
        dbFire.addDocument(data: ["Max": "Hey"])

        // Do any additional setup after loading the view.
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
