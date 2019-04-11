//
//  BarDetailViewController.swift
//  BingeCapstoneProject
//
//  Created by Brock Gibson on 2/16/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit
import MapKit

class BarDetailViewController: UIViewController {

    // Bar passed by selection from map or table
    var passedBar: Bar?
    
    @IBOutlet weak var barDescLabel: UILabel!
    @IBOutlet weak var barTitleLabel: UILabel!
    @IBOutlet weak var barInfoTextView: UITextView!
    @IBOutlet weak var barMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let bar = passedBar else {
            return
        }
        
        barTitleLabel.text = bar.name
        barDescLabel.text = bar.openingTime
//        barInfoTextView.text = bar.deals
        
        let center = CLLocationCoordinate2D(latitude: bar.latitude, longitude: bar.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let region = MKCoordinateRegion(center: center, span: span)
        barMapView.setRegion(region, animated: true)

        // Do any additional setup after loading the view.
    }
    

}
