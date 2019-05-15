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

class BarDetailViewController: UIViewController, MKMapViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var dealCollectionView: UICollectionView!
    // Bar passed by selection from map or table
    @IBOutlet weak var barDescLabel: UILabel!
    @IBOutlet weak var barTitleLabel: UILabel!
    @IBOutlet weak var barMapView: MKMapView!
    @IBOutlet weak var barImage: UIImageView!
    
    var selectedBar:Bar!
    
    override func viewDidLoad() {
        dealCollectionView.dataSource = self 
        super.viewDidLoad()
        barMapView.delegate = self
        barMapView.addInnerShadow(onSide: .top, shadowColor: UIColor.black, shadowSize: .init(20.0), cornerRadius: 0.0, shadowOpacity: 0.2)
        dealCollectionView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLabelValues(selectedBar)
        focusMapView(selectedBar)
        addPin(selectedBar)
        dealCollectionView.reloadData()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(selectedBar.deals.count)
        return selectedBar.deals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let deals = selectedBar.deals
        return deals[section].deals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "dealHour",
                    for: indexPath) as? HoursHeader
                else {
                    fatalError("Invalid view type")
            }
            
            let title = selectedBar.deals[indexPath.section].hours
            print(title)
            headerView.label.text = "Hours: \(title)"
            return headerView
        default:
            // 4
            assert(false, "Invalid element type")
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        collectionView.register(DealCell.self, forCellWithReuseIdentifier: "dealCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dealCell", for: indexPath)
        if let cell = cell as? DealCell{
            let deal = selectedBar.deals[indexPath.section].deals
            cell.label.text = deal[indexPath.row]
            return cell
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MapViewController {
            destination.selectedBar = selectedBar
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            print("User tapped on annotation with title: \(annotationTitle!)")
            openMapForPlace(selectedBar)
        }
    }

    func updateLabelValues(_ bar:Bar){
        barTitleLabel.text = bar.name
        barDescLabel.text = bar.hours
        barImage.kf.setImage(with: URL(string: bar.imageURL))
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


extension UIView
{
    // different inner shadow styles
    public enum innerShadowSide
    {
        case all, left, right, top, bottom, topAndLeft, topAndRight, bottomAndLeft, bottomAndRight, exceptLeft, exceptRight, exceptTop, exceptBottom
    }
    
    // define function to add inner shadow
    public func addInnerShadow(onSide: innerShadowSide, shadowColor: UIColor, shadowSize: CGFloat, cornerRadius: CGFloat = 0.0, shadowOpacity: Float)
    {
        // define and set a shaow layer
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        // define shadow path
        let shadowPath = CGMutablePath()
        
        // define outer rectangle to restrict drawing area
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        
        // define inner rectangle for mask
        let innerFrame: CGRect = { () -> CGRect in
            switch onSide
            {
            case .all:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            case .left:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .right:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .top:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case.bottom:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndLeft:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndRight:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndLeft:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndRight:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .exceptLeft:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptRight:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptTop:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            case .exceptBottom:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            }
        }()
        
        // add outer and inner rectangle to shadow path
        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)
        
        // set shadow path as show layer's
        shadowLayer.path = shadowPath
        
        // add shadow layer as a sublayer
        layer.addSublayer(shadowLayer)
        
        // hide outside drawing area
        clipsToBounds = true
    }
}


class HoursHeader:UICollectionReusableView{
    @IBOutlet weak var label: UILabel!
}

class DealCell:UICollectionViewCell{
    @IBOutlet weak var label: UILabel!

}
