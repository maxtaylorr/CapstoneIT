//
//  BarCollectionViewController.swift
//  BingeCapstoneProject
//
//  Created by Kolbe Weathington on 5/13/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation


private let reuseIdentifier = "barCell"

class BarCollectionViewController: UICollectionViewController {

    var barList:[Bar]!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bars = barData.bars{
            barList = Array(bars)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        barData.pullData()
        self.collectionView.reloadData()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return barData.bars!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BarCollectionViewCell{
        
            let currentBar = barList[indexPath.row]
            cell.barImage.kf.setImage(with: URL(string: currentBar.imageURL))
            cell.barTitleLabel.text = currentBar.name
            print("\(currentBar.name)")
            // TODO: Add accurate location data
            let centerLatitude = 38.948
            let centerLongitude = -92.328
            let coordinate₀ = CLLocation(latitude: centerLatitude, longitude: centerLongitude)
            let coordinate₁ = CLLocation(latitude: currentBar.coordinate.latitude, longitude: currentBar.coordinate.longitude)
            
            let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
            let distanceInMiles = distanceInMeters / 1609
            cell.BarDistanceLabel.text = "\(distanceInMiles) mi"
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
