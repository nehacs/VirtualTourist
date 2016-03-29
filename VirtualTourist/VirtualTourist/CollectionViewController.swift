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
    
    var annotation: MKAnnotation!
    var photos = [PhotoData]()
    
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
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        // Step 6: Set the delegate to this view controller
        fetchedResultsController.delegate = self
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
        
        let fetchRequest = NSFetchRequest(entityName: "Location")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "lat == %@", self.annotation.coordinate.latitude);
        fetchRequest.predicate = NSPredicate(format: "long == %@", self.annotation.coordinate.longitude);
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
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
                    let imageURL = NSURL(string: imageUrlString!)
                    let imageData = NSData(contentsOfURL: imageURL!)
                    if (imageData != nil) {
                        let newPhoto = PhotoData(image: UIImage(data: imageData!)!)
                        self.photos.append(newPhoto)
                    }
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
        photos = [PhotoData]()
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

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoReuseID", forIndexPath: indexPath) as! CollectionViewCell
        
        let photo = photos[indexPath.row]
        let photoImageView = UIImageView(image: photo.image)

        photoImageView.contentMode = UIViewContentMode.Redraw
        cell.photo.image = photoImageView.image
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        // TODO: Tapping on a photo should remove it from the collection
    }
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        self.collectionView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
//            switch type {
//            case .Insert:
//                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
//                
//            case .Delete:
//                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
//                
//            default:
//                return
//            }
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            
//            switch type {
//            case .Insert:
//                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
//                
//            case .Delete:
//                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
//                
//            case .Update:
//                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! ActorTableViewCell
//                let movie = controller.objectAtIndexPath(indexPath!) as! Movie
//                self.configureCell(cell, movie: movie)
//                
//            case .Move:
//                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
//                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
//            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        self.tableView.endUpdates()
    }
}