//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by Neha Agarwal on 2/27/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import UIKit
import MapKit

class CollectionViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    var annotation: MKAnnotation!
    var photos: [Photo]!
    
    func setMapViewAnnotation(annotation: MKAnnotation) {
        self.annotation = annotation;
    }
    
    override func viewDidLoad() {
        self.mapView.addAnnotation(annotation);
        self.mapView.centerCoordinate = annotation.coordinate
        
        FlickrClient.sharedInstance().getPhotosForLocation(annotation.coordinate) { (success, photos, errorString) in
            if success {
                print("count \(photos.count)")
            } else {
                print(errorString)
            }
        }
        
        let space: CGFloat = 3.0
        let dimension: CGFloat = (self.view.frame.size.width - (2*space))/3.0
        
        self.collectionFlowLayout.minimumInteritemSpacing = space
        self.collectionFlowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController")
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoReuseID", forIndexPath: indexPath) as! CollectionViewCell
        
//        let photo = photos[indexPath.row]
//        let photoImageView = UIImageView(image: photo.image)
//        
//        photoImageView.contentMode = UIViewContentMode.Redraw
//        cell.photo.image = photoImageView.image
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        // TODO: Tapping on a photo should remove it from the collection
        
//        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
//        detailController.meme = self.memes[indexPath.row]
//        self.navigationController!.pushViewController(detailController, animated: true)
    }
}