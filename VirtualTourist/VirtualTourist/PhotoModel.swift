//
//  PhotoModel.swift
//  VirtualTourist
//
//  Created by Neha Agarwal on 3/23/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import CoreData

class PhotoModel : NSManagedObject {
    struct Keys {
        static let ID = "id"
        static let Url = "url"
    }
    
    @NSManaged var url: String
    @NSManaged var id: NSNumber
    @NSManaged var location: Location?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        url = dictionary[Keys.Url] as! String
        id = dictionary[Keys.ID] as! Int
    }

//    var posterImage: UIImage? {
//
//        get {
//            return TheMovieDB.Caches.imageCache.imageWithIdentifier(posterPath)
//        }
//
//        set {
//            TheMovieDB.Caches.imageCache.storeImage(newValue, withIdentifier: posterPath!)
//        }
//    }
}