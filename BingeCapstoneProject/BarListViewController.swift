//  BarListViewController.swift
//  BingeCapstoneProject
//
//  Created by Brock Gibson on 2/16/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestore
import Kingfisher

class BarListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
SideView {
    var barList:Array<Bar> = []
    var directionToRoot: PushTransitionDirection = .left
    
    // table view iboutlet
    @IBOutlet weak var barsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        barList = Array(barData.bars?)
        barsTableView.dataSource = self
        barsTableView.delegate = self
        
        DispatchQueue.main.async {
            self.barsTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.init(named:"BingeWhite")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "barCell"
        let bar = barList[indexPath.row]
        let url = URL(string: bar.imageURL)
        //let processor = RoundCornerImageProcessor(cornerRadius: 20)
        //let processor = CroppingImageProcessor(size: CGSize(width: 100, height: 100), anchor: CGPoint(x: 0.5, y: 0.5))

        let cell = barsTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let cell = cell as? BarTableViewCell {
//            cell.barTitleLabel.text = bar.name
//            cell.BarDescLabel.text = bar.hours
//            cell.barImage.kf.setImage(with: url)
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BarDetailViewController, let selectedRow = barsTableView.indexPathForSelectedRow {
            destination.selectedBar = barList[selectedRow.row]
        }
    }

}
