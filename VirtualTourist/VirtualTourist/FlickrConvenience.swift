//
//  FlickrConvenience.swift
//  VirtualTourist
//
//  Created by Neha Agarwal on 2/28/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import Foundation
import MapKit

extension FlickrClient {
    
    func getPhotosForLocation(coordinate: CLLocationCoordinate2D, completionHandler: (success: Bool, photos: [[String: AnyObject]], errorString: String?) -> Void) {
        /* 1. Specify parameters */
        let parameters : [String:AnyObject] = [
            FlickrClient.ParameterKeys.Latitude: coordinate.latitude,
            FlickrClient.ParameterKeys.Longitude: coordinate.longitude,
        ]

        /* 2. Make the request */
        self.taskForGETMethod(Methods.PhotosSearch, parameters: parameters) { JSONResult, success, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if success {
                if let dictionary = JSONResult[FlickrClient.JSONResponseKeys.Photos] as? NSDictionary {
                    if let results = dictionary[FlickrClient.JSONResponseKeys.Photo] as? [[String: AnyObject]] {
                        completionHandler(success: true, photos: results, errorString: nil)
                    } else {
                        print("Could not find \(FlickrClient.JSONResponseKeys.Photo) in \(dictionary)")
                        completionHandler(success: false, photos: [], errorString: "Could not get results.")
                    }                    
                } else {
                    print("Could not find \(FlickrClient.JSONResponseKeys.Photos) in \(JSONResult)")
                    completionHandler(success: false, photos: [], errorString: "Could not get results.")
                }
            } else {
                print(error)
                completionHandler(success: false, photos: [], errorString: "Request Failed.")
            }
        }
    }
}