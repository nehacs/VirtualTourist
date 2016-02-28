//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by Neha Agarwal on 2/27/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import UIKit
import MapKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var annotation: MKAnnotation!
    
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
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController")
        self.presentViewController(controller, animated: true, completion: nil)
    }
}