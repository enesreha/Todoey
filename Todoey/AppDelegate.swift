//
//  AppDelegate.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/12/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
      // print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        //NSPersistentContainer is where we're gonna store all of our data. It's actually a SQLite database.
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    //This method saves our data when application gets terminated
    func saveContext () {
        let context = persistentContainer.viewContext // context is an area where we can change and update our data so we can undo and redo until we're happy with our data. And then we can save the data that's in the context or in the temporary area to the container which is for permenant storege. Context is similar to the staging area in Git.
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

