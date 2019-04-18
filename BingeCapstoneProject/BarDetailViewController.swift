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
        
        var dealsString: String = ""
        
        for dealHour in bar.deals {
            dealsString += "\(dealHour.hours) \n"
            
            for deal in dealHour.deals {
                dealsString += "\t \(deal) \n"
            }
            dealsString += "\n"
            
        }
        barInfoTextView.text = dealsString
        
        focusMapView(bar)
        addPin(bar)
    }
    
    func addPin(_ bar: Bar) {
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: bar.latitude, longitude: bar.longitude)
        annotation.coordinate = centerCoordinate
        annotation.title = bar.name
        barMapView.addAnnotation(annotation)
    }
    
    func focusMapView(_ bar: Bar) {
        let center = CLLocationCoordinate2D(latitude: bar.latitude, longitude: bar.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        barMapView.setRegion(region, animated: true)
        barMapView.showsUserLocation = true

    }
    
    func openMapForPlace() {
        guard let bar = passedBar else {
            return
        }
        
        let latitude:CLLocationDegrees =  bar.latitude
        let longitude:CLLocationDegrees =  bar.longitude
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(bar.name)"
        mapItem.openInMaps(launchOptions: options)
    }
}
