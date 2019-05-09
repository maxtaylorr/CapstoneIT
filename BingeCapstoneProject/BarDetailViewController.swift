//
//  BarDetailViewController.swift
//  BingeCapstoneProject
//
//  Created by Brock Gibson on 2/16/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class BarDetailViewController: UIViewController, MKMapViewDelegate {
    
    var barData: BarDatabaseController?
    
    // Bar passed by selection from map or table
    @IBOutlet weak var barDescLabel: UILabel!
    @IBOutlet weak var barTitleLabel: UILabel!
    @IBOutlet weak var barInfoTextView: UITextView!
    @IBOutlet weak var barMapView: MKMapView!
    @IBOutlet weak var barImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let selectedBar = barData?.selectedBar!
//
//        updateLabelValues(selectedBar)
//        updateDealList(selectedBar)
//        focusMapView(selectedBar)
//        addPin(selectedBar)
        
        barMapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            print("User tapped on annotation with title: \(annotationTitle!)")
//            openMapForPlace(view.annotation)
        }
    }
    
    func updateLabelValues(_ bar:Bar){
        barTitleLabel.text = bar.name
        barDescLabel.text = bar.hours
        barImage.kf.setImage(with: URL(string: bar.imageURL))
    }
    
    func updateDealList(_ bar:Bar){
        var dealsString: String = ""
        for dealHour in bar.deals {
            dealsString += "\(dealHour.hours) \n"
            for deal in dealHour.deals {
                dealsString += "\t \(deal) \n"
            }
            dealsString += "\n"
            
        }
        barInfoTextView.text = dealsString
    }
    
    func addPin(_ bar: Bar) {
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: bar.coordinate.latitude, longitude: bar.coordinate.longitude)
        annotation.coordinate = centerCoordinate
        annotation.title = bar.name
        barMapView.addAnnotation(annotation)
    }
    
    func focusMapView(_ bar: Bar) {
        let center = CLLocationCoordinate2D(latitude: bar.coordinate.latitude, longitude: bar.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        barMapView.setRegion(region, animated: true)
        barMapView.showsUserLocation = true

    }
    
    func openMapForPlace(_ bar:Bar) {
        
        
        let latitude:CLLocationDegrees =  bar.coordinate.latitude
        let longitude:CLLocationDegrees =  bar.coordinate.longitude
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
