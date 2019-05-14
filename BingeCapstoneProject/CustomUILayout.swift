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
    var barNameLayer : LayerView!
    
    let cornerRadius = 10
    let animationTime = 0.5
    
    var barName = UILabel()
    var barDistance = UILabel()
    var barHours = UILabel()
    
    override init(frame: CGRect) {
        width = Double(frame.width)
        height = Double(frame.height)
        super.init(frame: frame)
//        self.backgroundColor = nil
        
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
    
    func setupBarName(){
        let barNameLayer = LayerView(frame: .init(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height/2))
        
        barNameLayer.layer.backgroundColor = UIColor.red.cgColor
        
        let tapped1 = UITapGestureRecognizer(target: self, action: #selector(detectTap(_:)))
        barNameLayer.isUserInteractionEnabled = true
        barNameLayer.addGestureRecognizer(tapped1)
        barNameLayer.layer.mask = self.maskLayer
        
        barName = UILabel(frame: .init(x:0, y:0,width: 200,height: 21))
        barName.center = .init(x: barNameLayer.frame.midX, y:0)
        barName.textAlignment = NSTextAlignment.center
        barName.text = "Bar names"

        barNameLayer.addSubview(barName)
        barNameLayer.bringSubviewToFront(barName)
        self.barNameLayer = barNameLayer
        self.superview!.addSubview(barNameLayer)
    }
    
    func setupBarInfo(){
        let barInfoLayer = LayerView(frame: .init(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height/2))
        barInfoLayer.backgroundColor = UIColor.purple
        
        barHours = UILabel(frame: .init(x:0, y:0,width: 200,height: 21))
        barHours.center = .init(x: self.frame.midX, y: self.frame.minY + 50)
        barHours.textAlignment = NSTextAlignment.center
        barHours.text = "Bar hours"
        
        self.addSubview(barHours)
        self.bringSubviewToFront(barHours)
    }
    
    func update(){
        if let bar = selectedBar {
            barName.text = bar.name
            barHours.text = bar.hours
//            barName.drawText(in: barNameLayer.layer.frame)
        }
    }
}


