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
        barData.pullData()
        self.collectionView.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barData.bars!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let cell = cellA as? BarCollectionViewCell{
            let currentBar = barList[indexPath.row]
            cell.barImage.kf.setImage(with: URL(string: currentBar.imageURL))
            cell.barTitleLabel.text = currentBar.name
            // TODO: Add accurate location data
            let centerLatitude = 38.948
            let centerLongitude = -92.328
            let coordinate₀ = CLLocation(latitude: centerLatitude, longitude: centerLongitude)
            let coordinate₁ = CLLocation(latitude: currentBar.coordinate.latitude, longitude: currentBar.coordinate.longitude)
            
            let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
            let distanceInMiles = distanceInMeters / 1609
            cell.BarDistanceLabel.text = "\(distanceInMiles) mi"
            return cell
        }else{
            return cellA
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BarDetailViewController, let indexPath = collectionView.indexPathsForSelectedItems?.first {
            destination.selectedBar = barList[indexPath.row]
        }
    }

    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
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
