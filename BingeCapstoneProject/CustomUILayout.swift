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

class LayerView : UIView{
    
    public final override class var layerClass: AnyClass { return CAShapeLayer.self }

    override init(frame: CGRect) {
        super.init(frame: frame)
        (layer as? CAShapeLayer)?.borderColor = UIColor.purple.cgColor
        (layer as? CAShapeLayer)?.backgroundColor = UIColor.green.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UIMapLayer:LayerView, MKMapViewDelegate,CLLocationManagerDelegate{
    var selectedAnnotation:BarPointAnnotation?
    var mapView:MKMapView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMap()
        setupClipPlane()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMap(){
        let width = self.bounds.width
        let height = self.bounds.height
        
        let mapWidth = 0.95 * width
        let mapHeight = 0.97 * height
        
        let mapAnchorX = width/2 - mapWidth/2
        let mapAnchorY = height/2 - mapHeight/2
        
        mapView = MKMapView(frame: .init(x: mapAnchorX, y: mapAnchorY, width: mapWidth, height: mapHeight))
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        
        self.addSubview(mapView)
        self.bringSubviewToFront(mapView)
    }
    
    private func setupClipPlane(){
//        let width = self.bounds.width
//        let height = self.bounds.height
        
        self.mapView.layer.cornerRadius = 10.0
        self.layer.cornerRadius = 10.0

        mapView.layer.masksToBounds = true
    }
}

class UIBarHeader:LayerView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


