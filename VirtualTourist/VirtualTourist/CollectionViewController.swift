//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by Neha Agarwal on 2/27/16.
//  Copyright © 2016 Neha Agarwal. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollection: UIBarButtonItem!
    
    // Keep the changes. We will keep track of insertions, deletions, and updates.
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
    
    var annotation: MKAnnotation!
    var photos = [Photo]()
    
    func setMapViewAnnotation(annotation: MKAnnotation) {
        self.annotation = annotation;
    }
    
    override func viewDidLoad() {
        self.mapView.addAnnotation(annotation);
        self.mapView.centerCoordinate = annotation.coordinate
        
        let space: CGFloat = 3.0
        let dimension: CGFloat = (self.view.frame.size.width - (2*space))/3.0
        
        self.collectionFlowLayout.minimumInteritemSpacing = space
        self.collectionFlowLayout.minimumLineSpacing = space
        self.collectionFlowLayout.itemSize = CGSizeMake(dimension, dimension)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Step 2: Perform the fetch
        var error: NSError?
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
        }
        
        if let error = error {
            print("Error performing initial fetch: \(error)")
        }
        
        // Step 6: Set the delegate to this view controller
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchPhotos()
    }

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // Step 1 - Add the lazy fetchedResultsController property. See the reference sheet in the lesson if you
    // want additional help creating this property.
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        
        fetchRequest.sortDescriptors = []
//        fetchRequest.predicate = NSPredicate(format: "lat == %@", self.annotation.coordinate.latitude);
//        fetchRequest.predicate = NSPredicate(format: "long == %@", self.annotation.coordinate.longitude);
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }()
    
    func fetchPhotos() {
        // Reset the collection view to empty
        clearPhotos()
        
        // Fetch new photos
        FlickrClient.sharedInstance().getPhotosForLocation(annotation.coordinate) { (success, results, errorString) in
            if success {
//                if (results.count > 0) {
//                    let newPhoto = Photo(image: UIImage(named: "Placeholder")!)
//                    for _ in 1...results.count {
//                        self.photos.append(newPhoto);
//                    }
//                    self.collectionView?.reloadData()
//                    print("Done")
//                }
                for (photo) in results {
                    let imageUrlString = photo[FlickrClient.JSONResponseKeys.Url] as? String
                    let id = 1
                    //Int((photo[FlickrClient.JSONResponseKeys.Id] as? String)!)
                    let photoData : [String:AnyObject] = [
                        Photo.Keys.ID: id,
                        Photo.Keys.Url: imageUrlString!
                    ]
                    let newPhoto = Photo(dictionary: photoData, context: self.sharedContext)
                    self.photos.append(newPhoto)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView?.reloadData()
                    self.newCollection.enabled = true
                }
            } else {
                print(errorString)
            }
        }
    }
    
    func clearPhotos() {
        photos = [Photo]()
        self.collectionView.reloadData()
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController")
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func newCollectionAction(sender: AnyObject) {
        self.newCollection.enabled = false
        fetchPhotos()
    }

    func configureCell(cell: CollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let photo = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        
        let imageURL = NSURL(string: photo.url)
        let imageData = NSData(contentsOfURL: imageURL!)
        let photoImageView = UIImageView(image: UIImage(data: imageData!)!)
        cell.photo.image = photoImageView.image
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoReuseID", forIndexPath: indexPath) as! CollectionViewCell
        
//        let photo = photos[indexPath.row]
//        let imageURL = NSURL(string: photo.url)
//        let imageData = NSData(contentsOfURL: imageURL!)
//        let photoImageView = UIImageView(image: UIImage(data: imageData!)!)
//
//        photoImageView.contentMode = UIViewContentMode.Redraw
//        cell.photo.image = photoImageView.image
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        // TODO: Tapping on a photo should remove it from the collection
    }
    
    // MARK: - Fetched Results Controller Delegate
    
    // Whenever changes are made to Core Data the following three methods are invoked. This first method is used to create
    // three fresh arrays to record the index paths that will be changed.
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // We are about to handle some new changes. Start out with empty arrays for each change type
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths = [NSIndexPath]()
        updatedIndexPaths = [NSIndexPath]()
        
        print("in controllerWillChangeContent")
    }
    
    // The second method may be called multiple times, once for each Color object that is added, deleted, or changed.
    // We store the incex paths into the three arrays.
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            switch type{
                
            case .Insert:
                print("Insert an item")
                // Here we are noting that a new Color instance has been added to Core Data. We remember its index path
                // so that we can add a cell in "controllerDidChangeContent". Note that the "newIndexPath" parameter has
                // the index path that we want in this case
                insertedIndexPaths.append(newIndexPath!)
                break
            case .Delete:
                print("Delete an item")
                // Here we are noting that a Color instance has been deleted from Core Data. We keep remember its index path
                // so that we can remove the corresponding cell in "controllerDidChangeContent". The "indexPath" parameter has
                // value that we want in this case.
                deletedIndexPaths.append(indexPath!)
                break
            case .Update:
                print("Update an item.")
                // We don't expect Color instances to change after they are created. But Core Data would
                // notify us of changes if any occured. This can be useful if you want to respond to changes
                // that come about after data is downloaded. For example, when an images is downloaded from
                // Flickr in the Virtual Tourist app
                updatedIndexPaths.append(indexPath!)
                break
            case .Move:
                print("Move an item. We don't expect to see this in this app.")
                break
            }
    }
    
    // This method is invoked after all of the changed in the current batch have been collected
    // into the three index path arrays (insert, delete, and upate). We now need to loop through the
    // arrays and perform the changes.
    //
    // The most interesting thing about the method is the collection view's "performBatchUpdates" method.
    // Notice that all of the changes are performed inside a closure that is handed to the collection view.
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        print("in controllerDidChangeContent. changes.count: \(insertedIndexPaths.count + deletedIndexPaths.count)")
        
        collectionView.performBatchUpdates({() -> Void in
            
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.collectionView.reloadItemsAtIndexPaths([indexPath])
            }
            
            }, completion: nil)
    }
}