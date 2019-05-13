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
    var mapView:MKMapView!
    
    var barHeader:UIBarHeader!
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
        setupMapView()
        setupBarHeader()
        self.getCurrentLocation()
        self.createMap()
        self.setupMapViewLayer()
        if let bars = barData.bars{
            updateMapPins(Array(bars))
        }
        barHeader.setupMaskLayer()
        barHeader.collapseView()
        super.viewDidLoad()
    }
    
    func setupMapView(){
        let width = view.bounds.width
        let height = view.bounds.height
        
        let mapWidth = 0.95 * width
        let mapHeight = 0.9 * height
        
        let mapAnchorX = width/2 - mapWidth/2
        let mapAnchorY = height/2 - mapHeight/2
        
        let mapView = UIMapLayer(frame: .init(x: mapAnchorX, y: mapAnchorY, width: mapWidth, height: mapHeight))
        
        self.mapView = mapView.mapView
        mapView.mapView.delegate = self
        self.view.addSubview(mapView)
        view.bringSubviewToFront(mapView)
    }
    
    func setupBarHeader(){
        let width = Double(view.bounds.width)
        let height = Double(view.bounds.height)
        
        let boxWidth = Double(width)
        let boxHeight = Double(height) * 0.25
        
        let x = width/2 - boxWidth/2
        let y = height * 0.75
        
        self.barHeader = UIBarHeader(frame: .init(x: x, y: y, width: boxWidth, height: boxHeight))
        view.addSubview(barHeader)
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
    
    func createMap() {
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let region = MKCoordinateRegion(center: center, span: span)
        
        self.mapView.setRegion(region, animated: false)
        self.mapView.showsUserLocation = true
    }
    
    func updateMapPins(_ bars:Array<Bar>){
        for bar in bars{
            let point = BarPointAnnotation(bar)
            self.mapView.addAnnotation(point)
        }
    }
    
    func getCurrentLocation(){
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
