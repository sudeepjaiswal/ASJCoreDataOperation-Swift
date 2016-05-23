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
  }
  
  convenience init(privateMoc: NSManagedObjectContext!, mainMoc: NSManagedObjectContext!)
  {
    self.init()
    self.privateMoc = privateMoc
    self.mainMoc = mainMoc
    self.setup()
  }
  
  func setup()
  {
    if mainMoc == nil
    {
      
    }
  }
  
  lazy var appDelegateMoc: NSManagedObjectContext =
  {
    let appDelegate: AnyObject = UIApplication.sharedApplication().delegate!
    
    let mocSelector = Selector("managedObjectContext")
    assert(appDelegate.respondsToSelector(mocSelector), "If managedObjectContext is not present in AppDelegate, you must provide one that operates on the main queue while initializing the operation.")
    
    return appDelegate.performSelector(mocSelector) as NSManagedObjectContext
  }()
  
  func listenForMocSavedNotification()
  {
    
  }
  
  public func coreDataOperation()
  {
    
  }
}
