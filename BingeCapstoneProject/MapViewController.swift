//
//  MapViewController.swift
//  BingeCapstoneProject
//
//  Created by Jack Huffman on 4/9/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let centerLatitude = 38.948
    let centerLongitude = -92.328
    let latitudeDelta = 0.02
    let longitudeDelta = 0.02
    
    var db: Firestore!
    
    // Map View
    @IBOutlet weak var mapView: MKMapView!
    
    // selected pin on map
    var selectedAnnotation: BarPointAnnotation?
    
    // Location manager
    var locationManager = CLLocationManager()
    
    // array of bars
    var bars = [Bar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        getCurrentLocation()
        createMap()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        pullData()
        
        // create array of bars

//        makePointsOnMap(bars)
        
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
            view.isUserInteractionEnabled = true
            view.pinTintColor = .black
            view.canShowCallout = true
            view.animatesDrop = false
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func makePointOnMap(_ bar: Bar) {

        let point = BarPointAnnotation()
        point.bar = bar
        point.coordinate = CLLocationCoordinate2D(latitude: bar.latitude, longitude: bar.longitude)
        point.title = bar.name
        mapView.addAnnotation(point)
        
    }
    
    // perform segue when tapping callout info on pin
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            selectedAnnotation = view.annotation as? BarPointAnnotation
            performSegue(withIdentifier: "showDetailFromMap", sender: self)
        }
    }
    
        func pullData(){
            db.collection("bars_04_02_2019").getDocuments() { (querySnapshot, err) in
               
                var bars = [Bar]()
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
    
                        let bar = Bar(name: name, date: Date(), latitude: lat, longitude: lon, openingTime: hours, deals: [])
    
                        bars.append(bar)
                        self.makePointOnMap(bar)

                    }
                }
//                DispatchQueue.main.async {
//                    // not sure what to do here
//                }
            }
        }
    
    // pass Bar to BarDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BarDetailViewController, let annotation = selectedAnnotation, let bar = annotation.bar {
            destination.passedBar = bar
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

}
