//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Neha Agarwal on 2/27/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    // MARK: GET
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, success:Bool, error: String?) -> Void) -> NSURLSessionDataTask {
        /* Set the parameters */
        var mutableParameters = parameters
        mutableParameters[ParameterKeys.Method] = method
        mutableParameters[ParameterKeys.ApiKey] = Constants.RestApiKey
        mutableParameters[ParameterKeys.Extras] = Constants.Extras
        mutableParameters[ParameterKeys.Format] = Constants.Format
        mutableParameters[ParameterKeys.NoJsonCallback] = Constants.NoJsonCallback
        
        /* Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + FlickrClient.escapedParameters(mutableParameters)
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        print(request)
        /* Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            var errorString = ""
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                errorString = "There was an error with your request: \(error)"
                print(errorString)
                completionHandler(result: nil, success: false, error: errorString)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    errorString = "Your request returned an invalid response! Status code: \(response.statusCode)!"
                } else if let response = response {
                    errorString = "Your request returned an invalid response! Response: \(response)!"
                } else {
                    errorString = "Your request returned an invalid response!"
                }
                print(errorString)
                completionHandler(result: nil, success: false, error: errorString)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            FlickrClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, success: Bool, error: String) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let errorString = "Could not parse the data as JSON: '\(data)'"
            completionHandler(result: nil, success: false, error: errorString)
            print(errorString)
        }
        
        completionHandler(result: parsedResult, success: true, error: "")
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> FlickrClient {
        
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        
        return Singleton.sharedInstance
    }
}