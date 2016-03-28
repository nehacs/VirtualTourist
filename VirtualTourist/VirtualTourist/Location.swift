//
//  Location.swift
//  VirtualTourist
//
//  Created by Neha Agarwal on 3/23/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import CoreData

class Location : NSManagedObject {
    struct Keys {
        static let ID = "id"
        static let Name = "name"
        static let Lat = "lat"
        static let Long = "long"
    }
    
    @NSManaged var name: String
    @NSManaged var id: NSNumber
    @NSManaged var lat: String?
    @NSManaged var long: String?
    @NSManaged var photos: [Photo]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("Location", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        name = dictionary[Keys.Name] as! String
        id = dictionary[Keys.ID] as! Int
        lat = dictionary[Keys.Lat] as? String
        long = dictionary[Keys.Long] as? String
    }
}