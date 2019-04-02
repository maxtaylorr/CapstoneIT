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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pullData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return bars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // configure
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    private var listener: ListenerRegistration?
    
    fileprivate func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        // Display data from Firestore, part one
        
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    fileprivate func baseQuery() -> Query {
        // Firestore needs to use Timestamp type instead of Date type.
        // https://firebase.google.com/docs/reference/swift/firebasefirestore/api/reference/Classes/FirestoreSettings
        let firestore: Firestore = Firestore.firestore()
        let settings = firestore.settings
        // settings.areTimestampsInSnapshotsEnabled = true
        firestore.settings = settings
        return firestore.collection("restaurants").limit(to: 50)
    }
    
    func pullData() {
        
        let bars = Firestore.firestore().collection("bars").limit(to: 50)
        let listener = query?.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            
            //from https://codelabs.developers.google.com/codelabs/firestore-ios/#4
    
            let models = snapshot.documents.map { (document) -> Bar in
                if let model = Bar(dictionary: document.data()) {
                    return model
                } else {
                    print("Unable to initialize bars")
                }
            self.bars = models
            self.documents = snapshot.documents
    
            if self.documents.count > 0 {
                self.tableView.backgroundView = nil
            } else {
                self.tableView.backgroundView = self.backgroundView
            }
    
            self.tableView.reloadData()
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
