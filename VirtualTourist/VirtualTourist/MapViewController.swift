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
    }
}

