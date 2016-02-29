//
//  FlickrConstants.swift
//  VirtualTourist
//
//  Created by Neha Agarwal on 2/27/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    struct Constants {
        // MARK: REST API Key
        static let RestApiKey : String = "6c971ca3ccc7e749b9429e339c327069"
        
        // MARK: Secret
        static let SecretKey: String = "31213999f2745ada"
        
        // MARK: URLs
        static let BaseURL : String = "http://api.flickr.com/services/rest/"
        static let BaseURLSecure : String = "https://api.flickr.com/services/rest/"
        
        static let Format: String = "json"
        static let NoJsonCallback: String = "1"
        static let Extras: String = "url_m"
    }
    
    struct Methods {
        
        // MARK: Get photos by location
        static let PhotosSearch : String = "flickr.photos.search"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        // MARK: Authentication
        static let ApiKey = "api_key"
        
        static let Method = "method"
        static let Format = "format"
        static let NoJsonCallback = "nojsoncallback"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let Extras = "extras"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let Photos = "photos"
        static let Photo = "photo"
    }
}