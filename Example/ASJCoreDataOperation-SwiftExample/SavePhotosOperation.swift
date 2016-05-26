//
//  SavePhotosOperation.swift
//  CoreDataOperation
//
//  Created by sudeep on 23/05/16.
//  Copyright © 2016 sudeep. All rights reserved.
//

import UIKit
import CoreData

public class SavePhotosOperation: ASJCoreDataOperation
{
  public var photos = [[String: AnyObject]]()
  
  override public func coreDataOperation()
  {
    for photoInfo in photos
    {
      let fetchRequest = NSFetchRequest(entityName: "Photo")
      fetchRequest.fetchLimit = 1
      
      if let photoId = photoInfo["id"] {
        let predicate = NSPredicate(format: "photoId == %@", photoId as! NSNumber)
        fetchRequest.predicate = predicate
      }
      
      var photoManagedObject: Photo!
      
      do
      {
        let result = try privateMoc.executeFetchRequest(fetchRequest) as! [Photo]
        if result.count > 0 {
          photoManagedObject = result.first
        } else {
          photoManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: privateMoc) as! Photo
        }
        
        if let albumId = photoInfo["albumId"] as? NSNumber {
          photoManagedObject.albumId = albumId
        }
        
        if let photoId = photoInfo["id"] as? NSNumber {
          photoManagedObject.photoId = photoId
        }
        
        if let title = photoInfo["title"] as? String {
          photoManagedObject.title = title
        }
        
        if let url = photoInfo["url"] as? String {
          photoManagedObject.url = url
        }
        
        if let thumbnailUrl = photoInfo["thumbnailUrl"] as? String {
          photoManagedObject.thumbnailUrl = thumbnailUrl
        }
                
        do {
          try privateMoc.save()
        }
        catch let error as NSError {
          print("error saving photo: \(error.localizedDescription)")
        }
      }
      catch let error as NSError {
        print("error fetching existing photos: \(error.localizedDescription)")
      }
    }
  }
}
