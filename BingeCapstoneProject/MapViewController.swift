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

//Functions for UI Design
extension MapViewController{
    func setupMapViewLayer(){
//        let mapShape = CAShapeLayer()
//        view.layer.addSublayer(mapShape)
//        mapShape.strokeColor = UIColor.red.cgColor
//        mapShape.fillColor = UIColor.blue.cgColor
//        mapShape.lineWidth = .init(2.0)
//
//        let mapClipBorder = CGMutablePath()
////        mapClipBorder.addRoundedRect(in: mapView.bounds, cornerWidth: 10, cornerHeight: 10)
////        mapShape.path = mapClipBorder
//        mapClipBorder.addRect(rect)
//        mapShape.path = mapClipBorder
////
//        let parentNode = SKShapeNode(path: )
//
//        let boundingBoxNode = SKShapeNode(rectOf: self.view.calculateAccumulatedFrame().size)
//        boundingBoxNode.lineWidth = 1
//        boundingBoxNode.strokeColor = .black
//        boundingBoxNode.fillColor = .clear
//        boundingBoxNode.path = boundingBoxNode.path?.copy(dashingWithPhase: 0,
//                                                          lengths: [10,10])
//
//        parentNode.addChild(boundingBoxNode)
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,
SideView {
    
    var selectedAnnotation:BarPointAnnotation?
    var directionToRoot: PushTransitionDirection = .left

    //Test Constants
    let centerLatitude = 38.948
    let centerLongitude = -92.328
    let latitudeDelta = 0.02
    let longitudeDelta = 0.02
    
    // Map View
//    @IBOutlet weak var mapView: MKMapView!
    let annotationIdentifier = "barIdentifier"
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        let mapView = UIMapLayer()
        self.view.addSubview(mapView)
//        mapView.delegate = self
//        self.getCurrentLocation()
//        self.createMap()
//        self.setupMapViewLayer()
//        if let bars = barData.bars{
//            updateMapPins(Array(bars))
//        }
        super.viewDidLoad()
    }
    
    // create pins on map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view: MKPinAnnotationView
        
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
//            view.leftCalloutAccessoryView = UIImage()
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAnnotation = view.annotation as? MKPointAnnotation as? BarPointAnnotation
    }
    
    // pass Bar to BarDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BarDetailViewController, let annotation = selectedAnnotation {
            let bar = annotation.bar
            barData.selectedBar = bar
        }
    }
    
    // perform segue when tapping callout info on pin
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            selectedAnnotation = view.annotation as? BarPointAnnotation
            performSegue(withIdentifier: "showDetailFromMap", sender: self)
        }
    }
}

class BarPointAnnotation:MKPointAnnotation{
    let bar : Bar
    
    init(_ bar:Bar){
        self.bar = bar
        super.init()
        self.coordinate.longitude = bar.coordinate.longitude
        self.coordinate.latitude = bar.coordinate.latitude
        self.title = bar.name
    }
}



//Functions for Map creation and and updating
//extension MapViewController{
//    func createMap() {
//        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
//        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
//        let region = MKCoordinateRegion(center: center, span: span)
//
//        self.mapView.setRegion(region, animated: false)
//        self.mapView.showsUserLocation = true
//    }
//
//    func updateMapPins(_ bars:Array<Bar>){
//        for bar in bars{
//            let point = BarPointAnnotation(bar)
//            self.mapView.addAnnotation(point)
//        }
//    }
//
//    func getCurrentLocation(){
//        self.locationManager.requestAlwaysAuthorization()
//
//        // Use location in background
//        self.locationManager.requestWhenInUseAuthorization()
//
//        locationManager.delegate = self as CLLocationManagerDelegate
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//}
