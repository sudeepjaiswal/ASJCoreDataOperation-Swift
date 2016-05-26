//
//  Photo+CoreDataProperties.swift
//  CoreDataOperation
//
//  Created by sudeep on 23/05/16.
//  Copyright © 2016 sudeep. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {
  
  @NSManaged var albumId: NSNumber?
  @NSManaged var photoId: NSNumber?
  @NSManaged var thumbnailUrl: String?
  @NSManaged var title: String?
  @NSManaged var url: String?
  
}
