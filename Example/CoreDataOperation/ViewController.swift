//
//  ViewController.swift
//  CoreDataOperation
//
//  Created by sudeep on 22/05/16.
//  Copyright © 2016 sudeep. All rights reserved.
//

import UIKit
import CoreData

let photosUrl = "http://jsonplaceholder.typicode.com/photos"
let cellIdentifier = "cell"

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
  @IBOutlet var photosTableView: UITableView!
  var operationQueue: NSOperationQueue!
  var indicator: UIActivityIndicatorView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: Setup
  
  func setup()
  {
    operationQueue = NSOperationQueue()
    
    photosTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    
    indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    indicator.hidesWhenStopped = true
    indicator.transform = CGAffineTransformMakeScale(0.75, 0.75)
    
    let leftView = UIBarButtonItem(customView: indicator)
    navigationItem.leftBarButtonItem = leftView
  }
  
  @IBAction func downloadTapped(sender: UIButton)
  {
    shouldShowIndicator = true
    downloadPhotos()
  }
  
  var shouldShowIndicator: Bool = false
    {
    didSet
    {
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        
        self.navigationItem.rightBarButtonItem?.enabled = !self.shouldShowIndicator
        if self.shouldShowIndicator {
          self.indicator.startAnimating()
        } else {
          self.indicator.stopAnimating()
        }
      }
    }
  }
  
  func downloadPhotos()
  {
    let operation = NSBlockOperation { () -> Void in
      
      let url = NSURL(string: photosUrl)
      NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
        
        self.shouldShowIndicator = false
        
        if let jsonData = data
        {
          do {
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as! [[String: AnyObject]]
            self.savePhotosToCoreData(json)
          }
          catch let error as NSError {
            print("error parsing response to json: \(error.localizedDescription)")
          }
        }
        else if let error = error {
          print("error downloading photos: \(error.localizedDescription)")
        }
        
      }).resume()
    }
    
    operationQueue.addOperation(operation)
  }
  
  func savePhotosToCoreData(photos: [[String: AnyObject]])
  {
    let operation = SavePhotosOperation(privateMoc: self.photosPrivateMoc, mainMoc: nil)
    operation.photos = photos
    operationQueue.addOperation(operation)
  }
  
  // MARK: UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    let sectionInfo: NSFetchedResultsSectionInfo = fetchedResultsController.sections![section]
    return sectionInfo.numberOfObjects
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
    
    let photo: Photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
    cell.textLabel?.text = photo.title
    
    return cell
  }
  
  // MARK: NSFetchedResultsController
  
  lazy var fetchedResultsController: NSFetchedResultsController =
  {
    let fetchRequest = NSFetchRequest(entityName: "Photo")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "photoId", ascending: true)]
    
    let frc: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.photosPrivateMoc, sectionNameKeyPath: nil, cacheName: nil)
    frc.delegate = self
    
    do {
      try frc.performFetch()
    }
    catch let error as NSError {
      print("error performing fetch: \(error.localizedDescription)")
    }
    
    return frc
  }()
  
  lazy var photosPrivateMoc: NSManagedObjectContext =
  {
    var privateMoc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    privateMoc.persistentStoreCoordinator = appDelegate.persistentStoreCoordinator
    
    return privateMoc
  }()
  
  func controllerDidChangeContent(controller: NSFetchedResultsController)
  {
    NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
      self.photosTableView.reloadData()
    }
  }
}
