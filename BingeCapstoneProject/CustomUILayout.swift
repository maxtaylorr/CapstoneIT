//
//  CustomUILayout.swift
//  BingeCapstoneProject
//
//  Created by Kolbe Weathington on 5/12/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class UIMapLayer:UIView, MKMapViewDelegate,CLLocationManagerDelegate{
    var selectedAnnotation:BarPointAnnotation?
    var mapView:MKMapView!

    public final override class var layerClass: AnyClass { return CAShapeLayer.self }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        (layer as? CAShapeLayer)?.fillColor = UIColor.purple.cgColor
        (layer as? CAShapeLayer)?.backgroundColor = UIColor.green.cgColor

        
        mapView = .init()
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = self.frame.size.width-20
        let mapHeight:CGFloat = 300
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.center = self.center
        
        self.addSubview(mapView)
        self.bringSubviewToFront(mapView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}


