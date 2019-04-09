//
//  MapViewController.swift
//  BingeCapstoneProject
//
//  Created by Jack Huffman on 4/9/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let centerLatitude = 38.948
    let centerLongitude = -92.328
    let latitudeDelta = 0.02
    let longitudeDelta = 0.02
    
    // Map View
    @IBOutlet weak var mapView: MKMapView!
    
    // selected pin on map
    var selectedAnnotation: BarPointAnnotation?
    
    // Location manager
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLocation()
        createMap()
        
        // Do any additional setup after loading the view.
    }
    
    func createMap() {
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let region = MKCoordinateRegion(center: center, span: span)
        
        self.mapView.setRegion(region, animated: false)
        self.mapView.showsUserLocation = true
    }
    
    // create pins on map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        
        let annotationIdentifier = "barIdentifier"
        
        if (annotation.isKind(of: MKUserLocation.self)){
            return nil
        }
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = selectedAnnotation
            view = dequeuedView
        } else {
            
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.canShowCallout = true
            view.animatesDrop = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
//    func makePointOnMap(_ bar: Bar) {
//        let point = BarPointAnnotation()
//        point.bar = bar
//        point.coordinate = CLLocationCoordinate2D(latitude: bar.latitude, longitude: bar.longitude)
//        point.title = bar.name
//        mapView.addAnnotation(point)
//    }
    
    // perform segue when tapping callout info on pin
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            selectedAnnotation = view.annotation as? BarPointAnnotation
            performSegue(withIdentifier: "showBarDetail", sender: self)
        }
    }
    
    func getCurrentLocation()
    {
        self.locationManager.requestAlwaysAuthorization()
        
        // Use location in background
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
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
