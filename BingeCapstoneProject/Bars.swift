//
//  Bars.swift
//  BingeCapstoneProject
//
//  Created by Brock Gibson on 3/14/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import Foundation
import UIKit
//Data Model for Bar Lists

class Bar {
    
    let name: String
    let date: Date
    let latitude: Double
    let longitude: Double
    let openingTime: String
    var deals = [String]()

    init(name: String, date: Date, latitude: Double, longitude: Double, openingTime: String, deals: [String]) {
        self.name = name
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.openingTime = openingTime
        self.deals = deals
    }
}
