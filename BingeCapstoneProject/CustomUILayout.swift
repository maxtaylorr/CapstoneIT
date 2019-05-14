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
    var selectedBar:Bar?
    
    let width:Double
    let height:Double
    var maskLayer:CAShapeLayer?
    var collapsedPath:UIBezierPath?
    var expandedPath:UIBezierPath?
    var viewOpen:Bool = false
    
    let cornerRadius = 10
    let animationTime = 0.5
    
    override init(frame: CGRect) {
        width = Double(frame.width)
        height = Double(frame.height)
        super.init(frame: frame)
        
        let tapped1 = UITapGestureRecognizer(target: self, action: #selector(detectTap(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapped1)
        self.layer.cornerRadius = .init(integerLiteral: cornerRadius)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMaskLayer(){
        let bounds = self.bounds
        maskLayer = CAShapeLayer(layer: bounds)
        
        expandedPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: .init(integerLiteral: cornerRadius))
        
        collapsedPath = UIBezierPath(roundedRect: .init(x: Double(self.bounds.minX), y: Double(self.bounds.minY), width: Double(self.width), height: Double(self.height)/2), cornerRadius: .init(integerLiteral: cornerRadius))
        
        self.layer.mask = maskLayer
    }
    
    @objc func detectTap(_ recognizer:UITapGestureRecognizer) {
        toggleView()
    }
    
    func toggleView(){
        let anim = CABasicAnimation(keyPath: "path")
        let toView:UIBezierPath
        
        switch viewOpen {
        case false:
            viewOpen = true
            toView = collapsedPath!
            
            break
        case true:
            viewOpen = false
            toView = expandedPath!
            break
        }
        
        if let maskLayer = maskLayer{
            anim.fromValue = maskLayer.path
            anim.toValue = toView.cgPath
            anim.duration = animationTime
            anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            maskLayer.add(anim, forKey: nil)
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            maskLayer.path = toView.cgPath
            CATransaction.commit()
        }
    }
    
    func setupBarInfo(){
        if let bar = selectedBar {
            
        }
    }
}


