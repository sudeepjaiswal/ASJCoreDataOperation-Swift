//
//  CoreDataOperation.swift
//  CoreDataOperation
//
//  Created by sudeep on 23/05/16.
//  Copyright © 2016 sudeep. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataOperation: NSOperation
{
  public var privateMoc: NSManagedObjectContext!
  var mainMoc: NSManagedObjectContext!
  
  // MARK: Initialization
  
  override init()
  {
    super.init()
    self.setup()
  }
  
  convenience init(privateMoc: NSManagedObjectContext!, mainMoc: NSManagedObjectContext!)
  {
    self.init()
    self.privateMoc = privateMoc
    self.mainMoc = mainMoc
    self.setup()
  }
  
  // MARK: Setup
  
  func setup()
  {
    self.setupMocs()
    self.listenForMocSavedNotification()
  }
  
  func setupMocs()
  {
    if mainMoc == nil {
      mainMoc = self.appDelegateMoc
    }
    
    if privateMoc == nil
    {
      privateMoc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
      privateMoc.persistentStoreCoordinator = mainMoc.persistentStoreCoordinator
    }
    
    privateMoc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    privateMoc.undoManager = nil
  }
  
  lazy var appDelegateMoc: NSManagedObjectContext =
  {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var success = appDelegate.respondsToSelector("managedObjectContext")
    
    assert(success, "If managedObjectContext is not present in AppDelegate, you must provide one that operates on the main queue while initializing the operation.")
    
    return appDelegate.managedObjectContext
  }()
  
  // MARK: Notifications
  
  func listenForMocSavedNotification()
  {
    self.notificationCenter.addObserver(self, selector: "contextDidSave:", name: NSManagedObjectContextDidSaveNotification, object: privateMoc)
  }
  
  func contextDidSave(note: NSNotification)
  {
    if let _ = note.object?.isEqual(mainMoc) {
      return
    }
    
    mainMoc.performBlock { () -> Void in
      self.mainMoc.mergeChangesFromContextDidSaveNotification(note)
    }
  }
  
  deinit
  {
    self.notificationCenter.removeObserver(self)
  }
  
  lazy var notificationCenter: NSNotificationCenter =
  {
    return NSNotificationCenter.defaultCenter()
  }()
  
  // MARK: Overrides
  
  override public func main()
  {
    privateMoc.performBlock { () -> Void in
      self.coreDataOperation()
    }
  }
  
  public func coreDataOperation()
  {
    assert(false, "Method must be overridden in subclass: \(__FUNCTION__)")
  }
}
