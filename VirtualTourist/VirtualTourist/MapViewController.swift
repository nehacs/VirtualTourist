//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Neha Agarwal on 2/4/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        let uilgr = UILongPressGestureRecognizer(target: self, action: "addAnnotation:")
        uilgr.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(uilgr)
    }
    
   func addAnnotation(gestureRecognizer:UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                
                // TODO: Might need to move this into dispatch async
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks!.count > 0 {
                    let pm = placemarks![0] as CLPlacemark
                    
                    // not all places have thoroughfare & subThoroughfare so validate those values
                    annotation.title = pm.thoroughfare! + ", " + pm.subThoroughfare!
                    annotation.subtitle = pm.subLocality
                    self.mapView.addAnnotation(annotation)
                }
                else {
                    annotation.title = "Unknown Place"
                    self.mapView.addAnnotation(annotation)
                    print("Problem with the data received from geocoder")
                }
                self.mapView.addAnnotation(annotation)
            })
        }
    }
}

